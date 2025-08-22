#!/usr/bin/env node

const crypto = require("crypto");

console.log("生成Strapi安全密钥...\n");

const secrets = {
  JWT_SECRET: crypto.randomBytes(16).toString("base64"),
  APP_KEYS: `${crypto.randomBytes(16).toString("base64")},${crypto
    .randomBytes(16)
    .toString("base64")}`,
  API_TOKEN_SALT: crypto.randomBytes(16).toString("base64"),
  ADMIN_JWT_SECRET: crypto.randomBytes(16).toString("base64"),
  TRANSFER_TOKEN_SALT: crypto.randomBytes(16).toString("base64"),
  ENCRYPTION_KEY: crypto.randomBytes(16).toString("base64"),
};

console.log("请将这些密钥添加到您的环境变量中：\n");

Object.entries(secrets).forEach(([key, value]) => {
  console.log(`${key}=${value}`);
});

console.log("\n或者创建一个.env文件并添加这些变量。");
console.log("注意：在生产环境中，请使用更安全的密钥管理方式。");
