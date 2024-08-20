export const slashCommands = [
  {
    name: 'hello_world',
    name_localizations: {
      ja: '起動',
    },
    description: 'boot game server',
    guild_id: process.env.DISCORD_GUILD_ID,
    options: [
      {
        type: 4,
        name: 'server',
        name_localizations: {
          ja: 'サーバー',
        },
        description: 'target server',
        choices: [
          {
            name: 'ARK',
            value: 1,
          },
          {
            name: '7dtd',
            value: 2,
          }
        ],
      },
    ],
  },
  {
    name: 'monitor_world',
    name_localizations: {
      ja: '確認',
    },
    description: 'check game server status',
    guild_id: process.env.DISCORD_GUILD_ID,
    options: [
      {
        type: 4,
        name: 'server',
        name_localizations: {
          ja: 'サーバー',
        },
        description: 'target server',
        choices: [
          {
            name: 'ARK',
            value: 1,
          },
          {
            name: '7dtd',
            value: 2,
          }
        ],
      },
    ],
  },
  {
    name: 'stop_world',
    name_localizations: {
      ja: '休止',
    },
    description: 'kill game server',
    guild_id: process.env.DISCORD_GUILD_ID,
    options: [
      {
        type: 4,
        name: 'server',
        name_localizations: {
          ja: 'サーバー',
        },
        description: 'target server',
        choices: [
          {
            name: 'ARK',
            value: 1,
          },
          {
            name: '7dtd',
            value: 2,
          }
        ],
      },
    ],
  },
];
