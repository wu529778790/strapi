import { mergeConfig, type UserConfig } from "vite";

export default (config: UserConfig) => {
  // 从环境变量获取允许的主机列表
  const allowedHosts = process.env.VITE_ALLOWED_HOSTS
    ? process.env.VITE_ALLOWED_HOSTS.split(",").map((host) => host.trim())
    : ["localhost", "127.0.0.1", "strapi.shenzjd.com"];

  // Important: always return the modified config
  return mergeConfig(config, {
    resolve: {
      alias: {
        "@": "/src",
      },
    },
    server: {
      allowedHosts: allowedHosts,
    },
  });
};
