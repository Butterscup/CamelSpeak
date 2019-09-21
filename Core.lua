local CamelSpeak = LibStub('AceAddon-3.0'):NewAddon(
    'CamelSpeak',
    'AceConsole-3.0',
    'AceHook-3.0'
);

CamelSpeak.options = {
    type = 'group',
    args = {
        enabled = {
            name = 'Enable',
            desc = 'Enables / disables the addon',
            type = 'toggle',
            set = function(info, val)
                if val == true then
                    CamelSpeak:Enable();
                else
                    CamelSpeak:Disable();
                end
            end,
            get = function(info)
                return CamelSpeak:IsEnabled();
            end
        }
    }
};

CamelSpeak.defaults = {
    global = {
        enabled = true
    }
};

function CamelSpeak:OnInitialize()
    self.AceConfig = LibStub('AceConfig-3.0');
    self.AceConfigDialog = LibStub('AceConfigDialog-3.0');
    self.AceDB = LibStub('AceDB-3.0');

    self.AceConfig:RegisterOptionsTable('CamelSpeak', self.options, 'camelspeak');
    self.OptionsPanel = self.AceConfigDialog:AddToBlizOptions('CamelSpeak');
    self.db = self.AceDB:New('CamelSpeakDB', self.defaults, true);

    if ( not self.db.global.enabled ) then
        self:Disable();
    end

    self:RegisterChatCommand('camel', 'ToggleEnabled');

    self:Print('initialized');
end

function CamelSpeak:OnEnable()
    self:RawHook('SendChatMessage', true);
    self.db.global.enabled = true;
    self:Print('enabled');
end

function CamelSpeak:OnDisable()
    self:Unhook('SendChatMessage');
    self.db.global.enabled = false;
    self:Print('disabled');
end

function CamelSpeak:ToggleEnabled()
    if self:IsEnabled() then
        self:Disable();
    else
        self:Enable();
    end
end

function CamelSpeak:SendChatMessage(msg, chatType, language, channel)
    local upper = true;
    local newMsg = {};
    local i;

    for i = 1, msg:len() do
        local c = msg:sub(i, i);
        if c:match('%a') ~= nil then
            if upper then
                table.insert(newMsg, string.upper(c));
            else
                table.insert(newMsg, string.lower(c));
            end
            upper = not upper;
        else
            table.insert(newMsg, c);
        end
    end

    newMsg = table.concat(newMsg);
    self.hooks['SendChatMessage'](newMsg, chatType, language, channel);
end
