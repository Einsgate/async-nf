# Snort initialization
* It seems that the entry point of the packet loop is in analyzer.cc (src/main/analyzer.cc)

* In src/main/snort.cc, main_hook is set to DetectionEngine::inspect in snort_config.c.

* So, DetectionEngine::inspect will be executed after the packet is decoded?
