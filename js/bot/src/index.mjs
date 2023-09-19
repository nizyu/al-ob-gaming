import * as intaraction from 'discord-interactions';
import * as sakura from './sakura.mjs';

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
    const serverId = process.env["ARK_SERVER_ID"]
    const token = process.env["SAKURACLOUD_SERVER_POWER_TOKEN"]
    const secret = process.env["SAKURACLOUD_SERVER_POWER_TOKEN_SECRET"]
    let message = "知らないメッセージです。"

    if (request.name === "hello_world") {
      await sakura.powerOn(serverId, token, secret);
      message = "稼働開始します。"
    } else if (request.name === "monitor_world") {
      const result = await sakura.powerStatus(serverId, token, secret);
      message = `確認結果: ${result.powerStatus} です。`
    } else if (request.name === "stop_world") {
      await sakura.powerOff(serverId, token, secret);
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
