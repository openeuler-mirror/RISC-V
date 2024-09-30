// 定义继电器连接的引脚
const int relayPin = 4;

void setup() {
    // 初始化继电器引脚为输出模式
    pinMode(relayPin, OUTPUT);
    // 初始状态为关闭继电器
    digitalWrite(relayPin, LOW);
}

void loop() {
    // 打开继电器
    digitalWrite(relayPin, HIGH);
    Serial.println("Relay ON");
    delay(1000); // 延时1秒

    // 关闭继电器
    digitalWrite(relayPin, LOW);
    Serial.println("Relay OFF");
    delay(1000); // 延时1秒
}