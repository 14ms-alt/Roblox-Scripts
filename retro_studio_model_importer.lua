local ReplicatedStorage = game:GetService('ReplicatedStorage')
local MarketplaceService = game:GetService('MarketplaceService')

local CreateObject = ReplicatedStorage.RemoteFunctions.CreateObject
local ChangeObjectProperty = ReplicatedStorage.RemoteFunctions.ChangeObjectPropertyAndReturn

local PropertiesIds = require(ReplicatedStorage.PermissionData).PropertyNameToId
local HashLib = require(ReplicatedStorage.HashLib)

local total_instances = 0
local cur_instances = 0

-- Sets the value of the object instance property
local function set_property(instance: Instance, property_name: string, property_value: any)
	task.spawn(function()
		ChangeObjectProperty:InvokeServer(instance, property_name, property_value)
	end)
end

-- Sends a request to create an object instance
local function request_creation(class_name: string, parent: Instance): Instance
	local ts = os.clock()

	return CreateObject:InvokeServer(class_name, parent, HashLib.md5(tostring(ts) .. '\u{0D9E}'), ts)
end

-- Creates and returns an instance of the object class
local function create_instance(class_name: string, parent: Instance): (Instance, boolean)
	local created_instance = request_creation(class_name, parent)

	-- If the requested instance was not created, the folder will be created instead
	if not created_instance then
		warn('Failed to create an instance of the "' .. class_name .. '" object class.')
		return request_creation('Folder', parent), false
	end

	if created_instance:IsA('Part') then
		set_property(created_instance, 'FormFactor', Enum.FormFactor.Custom.Name)
	end

	return created_instance, true
end

local function copy_properties(reference_object: Instance, instance: Instance)
	local ref_props = PropertiesIds[reference_object.ClassName]

	for prop_name, _ in pairs(ref_props) do

		if prop_name == 'Parent' or prop_name == 'FormFactor' then continue end

		pcall(function() set_property(instance, prop_name, reference_object[prop_name]) end)
	end
end

local function copy_instance(reference_object: Instance, parent: Instance): Instance
	local created_instance, success = create_instance(reference_object.ClassName, parent)

	cur_instances = cur_instances + 1
	print('Importing progress: ' .. cur_instances .. '/' .. total_instances)

	if not success then
		set_property(created_instance, 'Name', '[' .. reference_object.ClassName .. '?] ' .. reference_object.Name)
		return created_instance
	end

	copy_properties(reference_object, created_instance)

	return created_instance
end

local function create_children(parent: Instance, children: table<Instance>)
	for _, child in pairs(children) do
		local child_children = child:GetChildren()

		if #child_children > 0 then
			local created = copy_instance(child, parent)

			task.spawn(create_children, created, child_children)
		else
			task.spawn(copy_instance, child, parent)
		end
	end
end

local function import_asset(asset_id: number)
	local asset_name = MarketplaceService:GetProductInfo(asset_id).Name
	local asset_objects = game:GetObjects('rbxassetid://' .. asset_id)

	for _, o in pairs(asset_objects) do
		total_instances = total_instances + #o:GetDescendants()
	end

	local root_folder = create_instance('Folder', workspace)
	set_property(root_folder, 'Name', asset_name)

	create_children(root_folder, asset_objects)
end

return import_asset
