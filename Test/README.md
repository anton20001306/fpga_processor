# Digital Electronics Test Projects (Nexys A7-100T)

This directory contains foundational digital logic design projects implemented in Verilog HDL and deployed on the **Digilent Nexys A7-100T Development Board** (featuring the Xilinx Artix-7 FPGA). 

---

## 📁 Included Projects

### 1. `not_gate`
* **Type:** Combinational Logic
* **Description:** A fundamental introductory project mapping a physical slider switch on the board to an onboard LED through an inverter (NOT gate).
* **Key Concepts:** RTL design entry, basic I/O pin mapping, combinational assignments.

### 2. `up_down_counter`
* **Type:** Sequential Logic
* **Description:** A synchronous counter that increments or decrements its value based on a control input (switch/button). It includes a reset mechanism and incorporates a clock divider network to slow down the onboard 100 MHz oscillator to a human-readable frequency (e.g., 1 Hz to 4 Hz) for displaying the binary count on the LEDs.
* **Key Concepts:** Sequential blocks (`always @(posedge clk)`), clock division, registers, conditional logic, up/down control.

---

## 🛠️ Step-by-Step Vivado Workflow Guide

Follow this standardized workflow to create, compile, and program any digital design project using Xilinx Vivado.

### Step 1: Creating a New Project
1. Open **Xilinx Vivado** (this guide assumes Vivado 2020.1 or newer).
2. Click **Create Project** on the welcome screen, or navigate to `File -> Project -> New`.
3. Click **Next** on the wizard introduction screen.
4. **Project Name:** Set a descriptive name (e.g., `up_down_counter`) and specify the project location. Click **Next**.
5. **Project Type:** Select **RTL Project** and ensure *Do not specify sources at this time* is checked (you will add them manually next). Click **Next**.
6. **Default Part (Target Device Selection):**
   * If you have the Digilent board files installed, switch to the **Boards** tab and select **Nexys A7-100T**.
   * If using part numbers directly, select the **Parts** tab and search for the target Artix-7 FPGA part: **`xc7a100tcsg324-1`**.
7. Click **Next**, then click **Finish** to initialize the workspace.

### Step 2: Adding Source and Constraint Files
#### A. Adding Verilog RTL Sources
1. In the *Sources* window, click the **+ (Add Sources)** button (or press `Alt + A`).
2. Select **Add or create design sources** and click **Next**.
3. To add an existing file, click **Add Files** and select your `.v` file. To start fresh, click **Create File**, name it, and set the file type to **Verilog**.
4. Click **Finish**. (If creating a new file, Vivado will prompt you to define I/O ports; you can define them here or skip and type them directly into the text editor).

#### B. Adding Xilinx Design Constraints (XDC)
The `.xdc` file links your Verilog module input/output ports to the actual physical copper pins of the FPGA connected to switches, LEDs, and clocks.
1. Click the **+ (Add Sources)** button again.
2. Select **Add or create constraints** and click **Next**.
3. Click **Add Files** to locate your target `.xdc` file (e.g., the standard `Nexys-A7-100T-Master.xdc`), or create a new one.
4. Open the `.xdc` file within Vivado, uncomment the lines corresponding to the I/O ports used in your module (such as `CLK100MHZ`, specific switches `SW[x]`, and LEDs `LED[x]`), and change the net names to exactly match the variable names in your Verilog port declaration.

### Step 3: Running Synthesis
Synthesis translates your high-level behavioral Verilog code into a gate-level netlist consisting of Look-Up Tables (LUTs), Flip-Flops (FFs), and multiplexers.
1. In the *Flow Navigator* panel on the left side, look under the *Synthesis* heading.
2. Click **Run Synthesis**.
3. Choose your run settings (default options are usually fine) and click **OK**.
4. Wait for the green spinning indicator in the top right corner to complete. Once finished, a dialog box will appear prompting you to view reports or move to the next step.

### Step 4: Running Implementation
Implementation takes the synthesized gate-level netlist and maps it to the specific physical hardware resources inside the Artix-7 chip, routing the physical connections between elements while trying to satisfy precise timing constraints.
1. In the completion dialog box, select **Run Implementation** and click **OK** (Alternatively, click **Run Implementation** under the *Implementation* heading in the *Flow Navigator*).
2. Monitor progress. This phase takes longer as it executes placement and routing optimization routines.

### Step 5: Generating the Bitstream
The bitstream is the final compiled binary configuration file (`.bit`) that contains the routing configuration data needed to program the FPGA hardware blocks.
1. Once implementation completes, select **Generate Bitstream** in the popup window and click **OK**.
2. If the prompt does not appear, click **Generate Bitstream** at the very bottom of the *Flow Navigator* under the *Program and Debug* heading.
3. Upon completion, a "Bitstream Generation Completed Successfully" message will show up.

### Step 6: Connecting Hardware
1. Connect your **Nexys A7-100T board** to your PC using a micro-USB cable via the **PROG / UART** port located on the edge of the board.
2. Ensure the power switch (located near the power jack/USB port) is flipped to the **ON** position. 
3. Verify that the power LED lights up and any onboard diagnostic/pre-programmed routines show activity.

### Step 7: Programming the Device
1. At the bottom of the *Flow Navigator*, expand the **Open Hardware Manager** dropdown menu and click **Open Target**, then choose **Auto Connect**. Vivado will scan your USB ports for the Xilinx Cable Target.
2. Once connected, your hardware target (`xc7a100t_0`) will show up in the hardware panel status bar.
3. Right-click your device part name and select **Program Device...**, or click the green **Program device** link text at the top notification banner.
4. Vivado will automatically populate the field with the generated `.bit` file path from your `.runs/impl_1/` directory.
5. Click **Program**. 

The **DONE** LED on the Nexys A7 board will illuminate, indicating that the configuration bitstream has been fully loaded into the FPGA fabric. You can now toggle physical switches to test your `not_gate` or `up_down_counter` functionality in real-time.
