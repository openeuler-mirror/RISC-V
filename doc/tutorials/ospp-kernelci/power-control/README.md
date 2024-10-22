电源控制有很多种方式，我这里使用的是继电器，有的开发板支持深度睡眠也可以直接通过引脚控制电源开关

这里给出两种方式的 c 代码

[通过 mqtt ](./mqtt-esp8266.c)

在同一局域网下可以使用以下命令控制继电器 进而控制设备电源

```shell
mosquitto_pub -h 192.168.0.158 -t "device/power" -m "RESET"
mosquitto_pub -h 192.168.0.158 -t "device/power" -m "ON"
mosquitto_pub -h 192.168.0.158 -t "device/power" -m "OFF"
```

[通过串口](./serialport-arduino-uno3.c)

通过让 slave 通过串口通信访问 arduino 开发板 控制继电器 进而控制设备电源

```shell
(echo "OFF"; sleep 1; echo "ON") | telnet 192.168.0.158 20001 
(echo "ON") | telnet 192.168.0.158 20001
(echo "OFF") | telnet 192.168.0.158 20001
```

