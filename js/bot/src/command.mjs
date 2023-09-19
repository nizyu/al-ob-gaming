export const slashCommands = [
  {
    name: 'hello_world',
    name_localizations: {
      ja: '働け',
    },
    description: 'boot game server',
    guild_id: process.env.DISCORD_GUILD_ID,
    options: [
      {
        type: 1,
        name: 'server',
        name_localizations: {
          ja: 'サーバー',
        },
        description: 'target server',
        choices: [
          {
            name: 'ARK',
            value: '1',
          },
        ],
      },
    ],
  },
  {
    name: 'monitor_world',
    name_localizations: {
      ja: '見てるぞ',
    },
    description: 'check game server status',
    guild_id: process.env.DISCORD_GUILD_ID,
    options: [
      {
        type: 1,
        name: 'server',
        name_localizations: {
          ja: 'サーバー',
        },
        description: 'target server',
        choices: [
          {
            name: 'ARK',
            value: '1',
          },
        ],
      },
    ],
  },
  {
    name: 'stop_world',
    name_localizations: {
      ja: '休め',
    },
    description: 'kill game server',
    guild_id: process.env.DISCORD_GUILD_ID,
    options: [
      {
        type: 1,
        name: 'server',
        name_localizations: {
          ja: 'サーバー',
        },
        description: 'target server',
        choices: [
          {
            name: 'ARK',
            value: '1',
          },
        ],
      },
    ],
  },
];
