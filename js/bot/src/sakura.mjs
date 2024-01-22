import axios from 'axios';

const powerAPI = (serverId) => `https://secure.sakura.ad.jp/cloud/zone/tk1a/api/cloud/1.1/server/${serverId}/power`;

export const powerOff = async (serverId, token, tokenSecret) =>
  axios.delete(powerAPI(serverId), {auth: {username: token, password: tokenSecret}})
    .then((res) => {
      if (res.status < 300) {
        return {status: res.status, success: res.data.Success};
      } else {
        throw new Error(`status: ${res.status}`);
      }
    });

export const powerOn = async (serverId, token, tokenSecret) =>
  axios.put(powerAPI(serverId), null, {auth: {username: token, password: tokenSecret}})
    .then((res) => {
      if (res.status < 300) {
        return {status: res.status, success: res.data.Success};
      } else {
        throw new Error(`status: ${res.status}`);
      }
    });


export const powerStatus = async (serverId, token, tokenSecret) =>
  axios.get(powerAPI(serverId), {auth: {username: token, password: tokenSecret}})
    .then((res) => {
      if (res.status < 300) {
        return {status: res.status, powerStatus: res.data.Instance.Status};
      } else {
        throw new Error(`status: ${res.status}`);
      }
    });



