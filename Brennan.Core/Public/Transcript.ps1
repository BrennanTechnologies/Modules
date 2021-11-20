try {Start-Transcript -Path $TranscriptPath} catch {}


try{ Stop-Transcript | Out-Null } catch {}
