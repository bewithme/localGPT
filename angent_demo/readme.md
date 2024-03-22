https://juejin.cn/post/7276327264265257015

https://cookbook.langchain.com.cn/docs/langchain-tools/
大模型会被多次调用，响应用户的时间可能会比较久，因此相应产品也就会限制在一些特定领域。
虽然不用写工具匹配规则，但是这也让这一块逻辑变成一个黑盒了，很难去精准的匹配或者调试。
对大模型本身能力要求很高，如果使用低参数大模型，很有可能无法识别问题并正确的分发给对应工具。

```shell
pip install --force-reinstall -v langchain==v0.0.147
```


to fix ValueError: ZeroShotAgent does not support multi-input
