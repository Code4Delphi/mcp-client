object MCPDM: TMCPDM
  OnCreate = DataModuleCreate
  Height = 300
  Width = 305
  object MCPClient: TTMSMCPClient
    Settings.GeminiModel = 'gemini-1.5-flash-latest'
    Settings.OpenAIModel = 'gpt-4o'
    Settings.OpenAISoundModel = 'gpt-4o-mini-tts'
    Settings.OpenAITranscribeModel = 'whisper-1'
    Settings.GrokModel = 'grok-beta'
    Settings.ClaudeModel = 'claude-sonnet-4-5-20250929'
    Settings.OllamaModel = 'llama3.2:latest'
    Settings.DeepSeekModel = 'deepseek-chat'
    Settings.PerplexityModel = 'llama-3.1-sonar-small-128k-online'
    Settings.OllamaHost = 'localhost'
    Settings.OllamaPath = '/api/chat'
    Settings.MistralModel = 'mistral-large-latest'
    Settings.MistralTranscribeModel = 'voxtral-mini-2507'
    Service = aiOpenAI
    Servers = <>
    ToolCallMode = tcmAllow
    OnLog = MCPClientLog
    Left = 144
    Top = 80
  end
  object SettingsDialog: TTMSMCPClientSettingsDialog
    Client = MCPClient
    OnAPIKeysChanged = SettingsDialogAPIKeysChanged
    OnServersChanged = SettingsDialogServersChanged
    Left = 144
    Top = 144
  end
end
