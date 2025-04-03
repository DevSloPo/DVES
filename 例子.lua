local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local Library = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BLibrary%5D'))()
local ThemeManager = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BThemeManager%5D'))()
local SaveManager = loadstring(game:HttpGet(repo ..'Gui%20Lib%20%5BSaveManager%5D'))()

local Options = getgenv().Linoria.Options
local Toggles = getgenv().Linoria.Toggles

local Window = Library:CreateWindow({
	-- 如果您希望菜单显示在中间，请将“居中”设定为true
	-- 如果希望菜单在创建时出现，请将AutoShow设置为true
	-- 如果你想在游戏中拥有可调整大小的窗口，将Resizable设置为true
	-- 如果不想使用Linoria游标，请将ShowCustomCursor设置为false
	-- 位置和大小在这里也是有效的选项
	-- 但是您不需要定义它们，除非:）

	Title = '哇真是一个好意见',
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true,
	TabPadding = 8,
	MenuFadeTime = 0.2
})

-- 回拨说明:
-- 通过初始元素参数传入回调函数（即回调=函数（值）...）作品
-- 但是，使用切换/选项。INDEX:OnChanged(函数(值)...)是推荐的做法。
-- 我强烈建议将UI代码与逻辑代码分离。即首先创建您的UI元素，然后再创建setup :OnChanged函数。

-- 您不必这样设置您的选项卡和组，这只是一种偏好。
local Tabs = {
	-- Creates a new tab titled Main
	Main = Window:AddTab('调试'),
	['UI Settings'] = Window:AddTab('UI控制'),
}

-- Groupbox和Tabbox继承相同的函数
-- 除了Tabbox之外，您必须调用选项卡上的函数（tab box:AddTab（name））
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Groupbox')

-- 我们还可以通过以下代码获得我们的主选项卡:
-- local LeftGroupBox = Window.Tabs.Main:AddLeftGroupbox('Groupbox')

-- 标签盒略有不同，但这里有一个基本的例子:-【【

local TabBox = Tabs.Main:AddLeftTabbox() -- 在左侧添加标签框

local Tab1 = TabBox:AddTab('Tab 1')
local Tab2 = TabBox:AddTab('Tab 2')

-- 您现在可以在添加到Tabbox的选项卡上调用AddToggle等
-- Groupbox:AddToggle
-- Arguments: 参数:索引，选项
LeftGroupBox:AddToggle('MyToggle', {
	Text = 'This is a toggle',
	Default = true, -- 默认值:true=允许，false=不允许
	Tooltip = 'This is a tooltip', -- 悬停在切换按钮上时显示的信息

	Callback = function(Value)
		print('[cb] MyToggle changed to:', Value)
	end
}):AddColorPicker('ColorPicker1', {
	Default = Color3.new(1, 0, 0),
	Title = 'Some color1', -- 可选。允许您拥有自定义颜色选择器标题（当您打开它时）
	Transparency = 0, -- 可选。启用此颜色选择器的透明度更改（保留为0表示禁用）

	Callback = function(Value)
		print('[cb] Color changed!', Value)
	end
}):AddColorPicker('ColorPicker2', {
	Default = Color3.new(0, 1, 0),
	Title = 'Some color2',
	Transparency = 0,

	Callback = function(Value)
		print('[cb] Color changed!', Value)
	end
}):AddColorPicker('ColorPicker3', {
	Default = Color3.new(0, 0, 1),
	Title = 'Some color3',
	Transparency = 0,

	Callback = function(Value)
		print('[cb] Color changed!', Value)
	end
})


-- 提取切换对象供以后使用:
-- Toggles.MyToggle.Value

-- Toggles是库添加到getgenv（）中的一个表
-- 您的索引与指定的索引切换，在这种情况下，它是' MyToggle '
-- 要获得切换的状态，您需要切换。价值

-- 当切换更新时调用传递的函数
Toggles.MyToggle:OnChanged(function()
	-- 这里我们得到了切换对象&然后得到了它的值
	print('MyToggle changed to:', Toggles.MyToggle.Value)
end)

-- 这应该打印到控制台:“我的切换状态改变了！新值:假"
Toggles.MyToggle:SetValue(false)

-- [[1/15/23 -弃用创建按钮的旧方法，转而使用表格-添加了双击按钮功能
--[[
	Groupbox:AddButton参数:{ Text = string，Func = function，double click = boolean Tooltip = string，}您可以在按钮上调用:AddButton来添加子按钮！
]]

local MyButton = LeftGroupBox:AddButton({
	Text = 'Button',
	Func = function()
		print('You clicked a button!')
		Library:Notify("This is a notification")
	end,
	DoubleClick = false,
	Tooltip = 'This is the main button'
})

local MyButton2 = MyButton:AddButton({
	Text = 'Sub button',
	Func = function()
		print('You clicked a sub button!')
		Library:Notify("This is a notification with sound", nil, 4590657391)
	end,
	DoubleClick = true, -- 您必须点击此按钮两次才能触发回拨
	Tooltip = 'This is the sub button (double click me!)'
})

--[[
	注意:你可以链接按钮方法！示例:left group box:add button({ Text = ' Kill all ',Func = Functions.KillAll，Tooltip = '这会杀死游戏中的所有人！'}):add button({ Text = ' Kick all '，Func = Functions.KickAll,Tooltip = '这会踢到游戏中的每个人！'})
]]

-- Groupbox:AddLabel
-- Arguments: Text, DoesWrap
LeftGroupBox:AddLabel('This is a label')
LeftGroupBox:AddLabel('This is a label\n\nwhich wraps its text!', true)

-- Groupbox:AddDivider -参数:无
LeftGroupBox:AddDivider()

--[[
	Groupbox:AddSlider参数:Idx，SliderOptions

	SliderOptions: {
		Text = string,
		Default = number,
		Min = number,
		Max = number,
		Suffix = string,
		Rounding = number,
		Compact = boolean,
		HideMax = boolean,
	}

	必须指定文本、默认值、最小值、最大值、舍入。后缀是可选的。舍入是精度的小数位数。压缩将隐藏滑块的标题标签HideMax将只显示值而不显示值&滑块压缩的最大值将做同样的事情
]]
LeftGroupBox:AddSlider('MySlider', {
	Text = 'This is my slider!',
	Default = 0,
	Min = 0,
	Max = 5,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		print('[cb] MySlider was changed! New value:', Value)
	end
})

-- Options是一个添加到getgenv（）的表，由library - You使用指定的索引对Options进行索引，在本例中它是“my Slider”-以获取slider的值。价值

local Number = Options.MySlider.Value
Options.MySlider:OnChanged(function()
	print('MySlider was changed! New value:', Options.MySlider.Value)
end)

-- 这应该打印到控制台:“MySlider已更改！新值:3英寸
Options.MySlider:SetValue(3)

-- Groupbox:AddInput
-- Arguments: Idx, Info
LeftGroupBox:AddInput('MyTextbox', {
	Default = 'My textbox!',
	Numeric = false, -- true / false, 只允许数字
	Finished = false, -- true / false, 仅当您按enter时呼叫回拨
	ClearTextOnFocus = true, -- true / false, 如果为false，当文本框聚焦时文本不会被清除
		
	Text = 'This is a textbox',
	Tooltip = 'This is a tooltip', -- 悬停在文本框上方时显示的信息

	Placeholder = 'Placeholder text', -- 框为空时的占位符文本- MaxLength也是一个选项，它是文本的最大长度

	Callback = function(Value)
		print('[cb] Text updated. New text:', Value)
	end
})

Options.MyTextbox:OnChanged(function()
	print('Text updated. New text:', Options.MyTextbox.Value)
end)

-- Groupbox:AddDropdown
-- Arguments: Idx, Info

LeftGroupBox:AddDropdown('MyDropdown', {
	Values = { 'This', 'is', 'a', 'dropdown' },
	Default = 1, -- 的数字索引value / string
	Multi = false, -- true / false, 允许选择多个选项

	Text = 'A dropdown',
	Tooltip = 'This is a tooltip', -- 悬停在下拉菜单上时显示的信息

	Callback = function(Value)
		print('[cb] Dropdown got changed. New value:', Value)
	end
})

Options.MyDropdown:OnChanged(function()
	print('Dropdown got changed. New value:', Options.MyDropdown.Value)
end)

Options.MyDropdown:SetValue('This')

-- 多下拉菜单
LeftGroupBox:AddDropdown('MyMultiDropdown', {
	-- 默认为数字索引（例如，“This”将为1，因为它在值列表中位于第一位）-默认也接受字符串-当前您不能使用下拉列表设置多个值

	Values = { 'This', 'is', 'a', 'dropdown' },
	Default = 1,
	Multi = true, -- true / false, allows multiple choices to be selected允许选择多个选项

	Text = 'A dropdown',
	Tooltip = 'This is a tooltip', -- 悬停在下拉菜单上时显示的信息

	Callback = function(Value)
		print('[cb] Multi dropdown got changed:', Value)
	end
})

Options.MyMultiDropdown:OnChanged(function()
	-- print('下拉列表已更改。新难度动作:', )  这里print显示，学点lua吧
	print('Multi dropdown got changed:')
	for key, value in next, Options.MyMultiDropdown.Value do
		print(key, value) -- 应该打印出这样的内容，真的
	end
end)

Options.MyMultiDropdown:SetValue({
	This = true,
	is = true,
})

LeftGroupBox:AddDropdown('MyPlayerDropdown', {
	SpecialType = 'Player',
	Text = 'A player dropdown',
	Tooltip = 'This is a tooltip', -- 悬停在下拉菜单上时显示的信息

	Callback = function(Value)
		print('[cb] Player dropdown got changed:', Value)
	end
})

-- Label:AddColorPicker
-- Arguments: Idx, Info

-- 您也可以将颜色选择器和按键选择器切换到一个开关

LeftGroupBox:AddLabel('Color'):AddColorPicker('ColorPicker', {
	Default = Color3.new(0, 1, 0), -- Bright green鲜绿色
	Title = 'Some color', -- 可选。允许您拥有自定义颜色选择器标题（当您打开它时）
	Transparency = 0, -- 可选。启用此颜色选择器的透明度更改（保留为0表示禁用）

	Callback = function(Value)
		print('[cb] Color changed!', Value)
	end
})

Options.ColorPicker:OnChanged(function()
	print('Color changed!', Options.ColorPicker.Value)
	print('Transparency changed!', Options.ColorPicker.Transparency)
end)

Options.ColorPicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

-- 标签:AddKeyPicker -参数:Idx，Info

local LeftGroupBox2 = Tabs.Main:AddLeftGroupbox('Groupbox #2');
LeftGroupBox2:AddLabel('Oh no...\nThis label spans multiple lines!\n\nWe\'re gonna run out of UI space...\nJust kidding! Scroll down!\n\n\nHello from below!', true)

local TabBox = Tabs.Main:AddRightTabbox() -- 在右侧添加Tabbox

-- 我们可以在分组框中做的任何事情，我们都可以在标签框中做（添加切换、添加滑动条、添加标签等）...)
local Tab1 = TabBox:AddTab('Tab 1')
Tab1:AddToggle('Tab1Toggle', { Text = 'Tab1 Toggle' });

local Tab2 = TabBox:AddTab('Tab 2')
Tab2:AddToggle('Tab2Toggle', { Text = 'Tab2 Toggle' });

-- 依赖框允许我们根据另一个UI元素的状态来控制UI元素的可见性。-例如，我们有一个“功能启用”开关，我们只希望在启用时显示滑块、下拉菜单等功能！-依赖框示例:
local RightGroupbox = Tabs.Main:AddRightGroupbox('Groupbox #3');
RightGroupbox:AddToggle('ControlToggle', { Text = 'Dependency box toggle' });

local Depbox = RightGroupbox:AddDependencyBox();
Depbox:AddToggle('DepboxToggle', { Text = 'Sub-dependency box toggle' });

-- 我们还可以嵌套依赖框！-当我们这样做时，我们的SupDepbox自动依赖于Depbox的可见性-在我们设置的任何附加依赖项之上
local SubDepbox = Depbox:AddDependencyBox();
SubDepbox:AddSlider('DepboxSlider', { Text = 'Slider', Default = 50, Min = 0, Max = 100, Rounding = 0 });
SubDepbox:AddDropdown('DepboxDropdown', { Text = 'Dropdown', Default = 1, Values = {'a', 'b', 'ĉ'} });

local SecretDepbox = SubDepbox:AddDependencyBox();
SecretDepbox:AddLabel('You found a seĉret!')

Depbox:SetupDependencies({
	{ Toggles.ControlToggle, true } -- 如果我们只想在开关关闭时显示我们的功能，我们也可以传递“false”！
});

SubDepbox:SetupDependencies({
	{ Toggles.DepboxToggle, true }
});

SecretDepbox:SetupDependencies({
	{ Options.DepboxDropdown, 'ĉ'} -- 在下拉列表的情况下，它会自动检查是否选择了指定的下拉列表值
})

-- 库函数-设置水印可见性
Library:SetWatermarkVisibility(true)

-- 具有共同特征（fps和ping）的动态更新水印的示例
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
	FrameCounter += 1;

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter;
		FrameTimer = tick();
		FrameCounter = 0;
	end;

	Library:SetWatermark(('RNGNBNB | %s fps | %s ms'):format(
		math.floor(FPS),
		math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
	));
end);

Library.MM2toFrame.Visible = true; -- todo:为此添加一个函数>

Library:OnUnload(function()
	WatermarkConnection:Disconnect()

	print('Unloaded!')
	Library.Unloaded = true
end)

-- 用户界面设置
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- 我设置了NoUI，所以它不会出现在键绑定菜单中
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuMM2to', { Default = 'End', NoUI = true, Text = 'Menu MM2to' })

Library.ToggleMM2to = Options.MenuMM2to -- 允许您为菜单定制一个键绑定

-- 插件:-保存管理器（允许你有一个配置系统）-主题管理器（允许你有一个菜单主题系统）-把库交给我们的经理
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- 忽略主题管理器使用的键。-（我们不希望配置保存主题，是吗？)
SaveManager:IgnoreThemeSettings()

-- 将我们的MenuMM2to添加到忽略列表中-（您希望每个配置都有不同的菜单键吗？可能不会。)
SaveManager:SetIgnoreIndexes({ 'MenuMM2to' })

-- 这样做的用例:-脚本中枢可以在一个全局文件夹中拥有主题-而游戏配置在每个游戏的单独文件夹中
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

-- 在选项卡的右侧构建我们的配置菜单
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- 在左侧构建我们的主题菜单（包含大量内置主题）-注意:您也可以调用ThemeManager:ApplyToGroupbox将其添加到特定的分组框中
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- 您可以使用SaveManager:LoadAutoloadConfig（）来加载一个配置-该配置已被标记为自动加载！
SaveManager:LoadAutoloadConfig()