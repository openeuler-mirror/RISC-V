#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// WiFi 配置
const char* ssid = "feifei_cpe";         // 替换为你的 WiFi SSID
const char* password = "feifei0827"; // 替换为你的 WiFi 密码

// MQTT 服务器配置
const char* mqtt_server = "192.168.0.158"; // 替换为您的 MQTT 服务器地址
const char* mqtt_topic = "device/power"; // 控制主题

// GPIO 引脚
const int relayPin = 4; // 继电器控制引脚

WiFiClient espClient;
PubSubClient client(espClient);

void setup() {
  Serial.begin(115200);
  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, LOW); // 初始状态关闭继电器

  // 连接到 WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("连接中...");
  }
  Serial.println("WiFi 连接成功");

  // 设置 MQTT 服务器
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);

  // 连接到 MQTT
  reconnect();
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
}

// MQTT 消息回调函数
void callback(char* topic, byte* payload, unsigned int length) {
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }

  if (message == "ON") {
    digitalWrite(relayPin, HIGH); // 打开继电器
    Serial.println("电源已打开");
  } else if (message == "OFF") {
    digitalWrite(relayPin, LOW); // 关闭继电器
    Serial.println("电源已关闭");
  } else if (message == "RESET") {
    Serial.println("重置设备...");
        digitalWrite(relayPin, LOW); // 关闭继电器
    Serial.println("电源已关闭");
    delay(500);
        digitalWrite(relayPin, HIGH); // 打开继电器
    Serial.println("电源已打开");
  }
}

// 连接到 MQTT 服务器
void reconnect() {
  while (!client.connected()) {
    Serial.print("连接到 MQTT...");
    if (client.connect("ESP8266Client")) {
      Serial.println("连接成功");
      client.subscribe(mqtt_topic);
    } else {
      Serial.print("失败，状态码=");
      Serial.print(client.state());
      delay(2000);
    }
  }
}