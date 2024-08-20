import * as intaraction from 'discord-interactions';
import * as sakura from './sakura.mjs';
import { setTimeout } from 'timers/promises';

export const handler = async (event) => {
  if (!verifyRequest(event)) {
    return {
      statusCode: 400,
    };
  }

  const request = JSON.parse(event.body);

  const response = await handleInteraction(request)
	
  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(response),
  };
};

const verifyRequest = (event) => {
  const { headers, body } = event;
  const lowerHeader = lowercaseKeys(headers);

  const signature = lowerHeader["x-signature-ed25519"];
  const timestamp = lowerHeader["x-signature-timestamp"];
  const publicKey = process.env["DISCORD_PUBLIC_KEY"];
  if (!body || !signature || !timestamp || !publicKey) {
    return false;
  }
  return intaraction.verifyKey(body, signature, timestamp, publicKey);
};

const lowercaseKeys = (obj) => {
  return Object.fromEntries(
    Object.entries(obj).map(([key, value]) => [key.toLowerCase(), value])
  );
};

// interaction の処理
const handleInteraction = async (request) => {
  if (request.type === intaraction.InteractionType.APPLICATION_COMMAND) {
    console.log(JSON.stringify(request), null, 2);
    const token = process.env["SAKURACLOUD_SERVER_POWER_TOKEN"]
    const secret = process.env["SAKURACLOUD_SERVER_POWER_TOKEN_SECRET"]
    
    const choice = request.data.options[0].value
    let serverId = null
    if (choice === 1) {
      serverId = process.env["ARK_SERVER_ID"]
    } else if (choice === 2) {
      serverId = process.env["SDTD_SERVER_ID"]
    }

    let message = "知らないメッセージです。"
    if (request.data.name === "hello_world") {
      sakura.powerOn(serverId, token, secret);
      await setTimeout(200);
      message = "稼働開始します。"
    } else if (request.data.name === "monitor_world") {
      const result = await sakura.powerStatus(serverId, token, secret);
      message = `確認結果: ${result.powerStatus} です。`
    } else if (request.data.name === "stop_world") {
      sakura.powerOff(serverId, token, secret);
      await setTimeout(200);
      message = `おやすみなさい。`
    }

    return {
      type: intaraction.InteractionResponseType.CHANNEL_MESSAGE_WITH_SOURCE,
      data: {
        content: message,
      },
    };
  }

  return { type: intaraction.InteractionResponseType.PONG };
};

