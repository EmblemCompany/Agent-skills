# Troubleshooting

## Common Issues and Solutions

### Installation Issues

| Issue | Solution |
|-------|----------|
| `emblemai: command not found` | Run: `npm install -g @emblemvault/agentwallet` |
| npm permission errors | Use `sudo npm install -g @emblemvault/agentwallet` or configure npm permissions |
| Node.js version too old | Update Node.js to version 18.0.0 or higher |
| Package download fails | Check network connectivity: `npm config get registry` |

### Authentication Issues

| Issue | Solution |
|-------|----------|
| "Password must be at least 16 characters" | Use a longer password (minimum 16 characters) |
| "Authentication failed" | Check network connectivity to auth service |
| Browser doesn't open for auth | Copy the printed URL and open it manually |
| Session expired | Run `emblemai` again — browser will open for fresh login |
| "Invalid credentials" | Ensure you're using the correct password (no typos) |
| Authentication timeout | Increase timeout: wait up to 5 minutes for browser auth |

### Runtime Issues

| Issue | Solution |
|-------|----------|
| **Slow response** | Normal — queries can take up to 2 minutes for complex operations |
| No response after 2+ minutes | Check network connectivity; press Ctrl+C and retry |
| glow not rendering | Install glow: `brew install glow` (optional, falls back to plain text) |
| Plugin not loading | Check that the npm package is installed correctly |
| Memory issues | Ensure sufficient RAM; complex queries may require 1GB+ |
| Terminal display issues | Ensure terminal supports 256 colors; try `export TERM=xterm-256color` |

### Configuration Issues

| Issue | Solution |
|-------|----------|
| Environment variable not recognized | Configure credentials in your local shell/session tooling and retry; never paste secrets into chat responses |
| Config file permissions | Check permissions: `ls -la ~/.emblemai/` (should be 600/700) |
| Corrupted session file | Preferred: `/auth` -> Logout, then rerun `emblemai`; fallback: `rm ~/.emblemai/session.json` |
| History not persisting | Check write permissions: `touch ~/.emblemai/history/test.json` |
| Log file not created | Check directory permissions: `mkdir -p ~/.emblemai` |

### Network Issues

| Issue | Solution |
|-------|----------|
| Cannot connect to Hustle API | Check firewall/network settings |
| SSL certificate errors | Update system certificates or use `--hustle-url` with HTTP (not recommended) |
| Proxy issues | Configure npm proxy: `npm config set proxy http://proxy:port` |
| DNS resolution failures | Check DNS settings; try using IP addresses in URLs |

## Performance Optimization

### Response Time Management

**Expected response times:**
- Simple queries (balances, addresses): 5-15 seconds
- Market data queries: 15-30 seconds
- Trading operations: 30-60 seconds
- Complex DeFi operations: 60-120 seconds

**If responses are consistently slow:**
1. Check internet connection speed
2. Monitor system resources (CPU, memory)
3. Try during off-peak hours
4. Use simpler queries

## Debugging

### Enable Debug Mode

```bash
# Start with debug mode
emblemai --debug

# Or enable during runtime
/debug on
```

Debug mode shows:
- Tool arguments and parameters
- Intent context and parsing
- Network request details
- Response processing steps

### Logging

```bash
# Enable logging
emblemai --log

# Custom log file location
emblemai --log --log-file /path/to/custom.log
```

Log files contain:
- Timestamped messages
- User queries and AI responses
- Error messages and stack traces
- Performance metrics

### Common Error Messages

| Error Message | Meaning | Solution |
|---------------|---------|----------|
| `ECONNREFUSED` | Cannot connect to API | Check network, verify API URL |
| `ETIMEDOUT` | Connection timeout | Increase timeout, retry later |
| `ENOTFOUND` | DNS resolution failed | Check DNS settings |
| `EACCES` | Permission denied | Check file permissions |
| `ENOSPC` | Disk space full | Free up disk space |
| `EMFILE` | Too many open files | Increase file descriptor limit |

## Recovery Procedures

### Password Recovery

**Important:** There is no password recovery mechanism. If you lose your password, you lose access to the wallet.

**Prevention:**
1. Use a password manager
2. Create secure backups
3. Use the `/auth` > Backup Agent Auth feature
4. Store password in multiple secure locations

### Session Recovery

If your session is corrupted or expired:

```bash
# Preferred: use the interactive menu
# /auth -> Logout

# Start fresh
emblemai

# Fallback only if menu is unavailable:
rm ~/.emblemai/session.json
emblemai
```

### Configuration Reset

To reset all configuration safely:

```bash
# REQUIRED: backup before any reset
TS=$(date +%Y%m%d-%H%M%S)
cp -r ~/.emblemai ~/.emblemai.backup.$TS

# Do not hard-delete wallet files; quarantine instead
mv ~/.emblemai ~/.emblemai.quarantine.$TS

# Start fresh
emblemai
```

### Conversation History Reset

```bash
# Clear history
emblemai --reset

# Or manually
rm ~/.emblemai/history/*.json
```

## Getting Help

### Community Support

- **GitHub Issues**: [github.com/EmblemCompany/EmblemAi-AgentWallet/issues](https://github.com/EmblemCompany/EmblemAi-AgentWallet/issues)
- **Discord**: [discord.gg/Q93wbfsgBj](https://discord.gg/Q93wbfsgBj)
- **Documentation**: [emblemvault.dev/docs](https://emblemvault.dev/docs)

### Diagnostic Information

When reporting issues, include:

```bash
# System information
node --version
npm --version
uname -a

# Package information
npm list -g @emblemvault/agentwallet

# Configuration (sanitized)
ls -la ~/.emblemai/
```
