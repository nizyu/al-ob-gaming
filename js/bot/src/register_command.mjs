import axios from 'axios'; 
import { slashCommands } from './command.mjs';

const requests = slashCommands.map((command) => {
  return axios.post(
    `https://discord.com/api/v8/applications/${process.env["DISCORD_APPLICATION_ID"]}/commands`,
    command,
    { headers: {"Content-Type": "application/json", "Authorization": `Bot ${process.env["DISCORD_BOT_ACCESS_TOKEN"]}`} }
  )
});

axios.all(requests).then((res) => {
  res.forEach((r) => console.log({status: r.status, data: r.data}));
});

