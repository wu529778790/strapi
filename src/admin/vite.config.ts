import { mergeConfig, type UserConfig } from "vite";

export default (config: UserConfig) => {
  // Important: always return the modified config
  return mergeConfig(config, {
    resolve: {
      alias: {
        "@": "/src",
      },
    },
    server: {
      allowedHosts: [
        process.env.ALLOWED_HOST || "strapi.shenzjd.com",
        "localhost",
        "127.0.0.1",
      ],
      host: "0.0.0.0",
      port: 1337,
    },
  });
};
