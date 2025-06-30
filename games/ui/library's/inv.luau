local module    = {};
type Boolean    = typeof(true);
type Table      = typeof({});
type String      = typeof('');
type Color3      = typeof(Color3.new(0, 0, 0));

local Gui       = game:GetObjects('rbxassetid://83155345913917')[1].GuiMain:Clone();
local Text      = game:GetObjects('rbxassetid://83155345913917')[1].Text:Clone();
local Window    = Gui.Window;
local Items     = {};
Gui.Parent      = gethui();

Services = setmetatable({}, {__index = newcclosure(function(self, idx)
	return rawget(self, idx) or (newcclosure(function()
		rawset(self, idx, cloneref(UserSettings().GetService(game, idx)));
		return rawget(self, idx);
	end))();
end)});

module.SET_VISIBLE = function (val: Boolean)
	Gui.Enabled = val;
end;

module.SET_TEXT = function (val: Table)
	Window['Topbar']['Left'].Text = (val.Left or '');
	Window['Topbar']['Right'].Text = (val.Right or '');
end;

module.ADD_ITEM = function(name: String, Color: Color3, flag: String)
	local text = Text:Clone();
	text.Text = name;
	text.TextColor3 = (Color or text.TextColor3);
	text.Parent = Window['Holder'];
	Items[(flag or tostring(math.random(-99999999, 99999999)))] = text;
end;

module.UPDATE_ITEM = function (flag: String, name: String, Color: Color3)
	if Items[flag] then
		local text = Items[flag];
		text.Text = name;
		text.TextColor3 = (Color or text.TextColor3);
	end;
end;

module.DEL_ALL_ITEMS = function ()
	for i, v in next, (Window['Holder']:GetChildren()) do
		if v:IsA('TextLabel') then
			v:Destroy();
		end;
	end;
end;

local dragInput, dragStart, startPos, dragging = nil, nil, nil, false;
Window.InputBegan:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		dragging = true;
		dragStart = input.Position;
		startPos = Window.Position;
		input.Changed:Connect(function()
			if (input.UserInputState == Enum.UserInputState.End) then
				dragging = false;
			end;
		end);
	end;
end);

Window.InputChanged:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		dragInput = input;
	end;
end);

Services.UserInputService.InputChanged:Connect(function(input)
	if (input == dragInput and dragging) then
		Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position - dragStart).X, startPos.Y.Scale, startPos.Y.Offset + (input.Position - dragStart).Y);
	end;
end);

return module
