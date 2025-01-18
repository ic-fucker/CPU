# 复现《自己动手写CPU》中的OpenMIPS CPU

目标：实现MIPS32指令集，完成书中实践版的CPU。

## 注意

使用**iverilog**编译，iverilog官网提供的压缩包自带仿真器。

**Makefile**中的编译指令全都使用**iverilog**对源文件进行编译

---

## 项目结构

```
<div>

MIPS32CPU/  
├── head/  
│   └── defines.v  
│
├── source/  
│   ├── design/  
│   │   ├── pc_reg.v  
│   │   └── if_id.v  
│   │
│   └── sim/  
│       └── tb_pc_reg.v  
│
├── build/  
│   ├── a.out  
│   └── wave.vcd  
│   ...  
│
├── Makefile  
│
└── README.md

</div>
```

## 下载

`git clone https://github.com/ic-fucker/cpu.git`

## Makefile的使用

- `make pc_reg` : 编译pc_reg.v，生成pc_reg.out。  
- `make tb_pc_reg` : 编译链接pc_reg.v、tb_pc_reg.v，生成a.out、wave.vcd，并自动打开gtkwave。  
- `make clean` : 删除build目录下所有文件。  
