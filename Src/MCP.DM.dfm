object MCPDM: TMCPDM
  Height = 339
  Width = 432
  object MCPClient: TTMSMCPClient
    Settings.GeminiModel = 'gemini-1.5-flash-latest'
    Settings.OpenAIModel = 'gpt-4o'
    Settings.GrokModel = 'grok-beta'
    Settings.ClaudeModel = 'claude-3-5-sonnet-20241022'
    Settings.OllamaModel = 'llama3.2:latest'
    Settings.DeepSeekModel = 'deepseek-chat'
    Settings.PerplexityModel = 'llama-3.1-sonar-small-128k-online'
    Settings.OllamaHost = 'localhost'
    Settings.OllamaPath = '/api/chat'
    Settings.MistralModel = 'mistral-large-latest'
    Service = aiOpenAI
    Servers = <>
    Left = 104
    Top = 72
  end
  object SettingsDialog: TTMSMCPClientSettingsDialog
    Client = MCPClient
    OnAPIKeysChanged = SettingsDialogAPIKeysChanged
    OnServersChanged = SettingsDialogServersChanged
    Left = 104
    Top = 136
  end
end
