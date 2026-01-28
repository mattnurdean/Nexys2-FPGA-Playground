import uvm_pkg::*;
`include "uvm_macros.svh"

// 1. INTERFACE
interface blinky_if(input logic clk);
    logic [0:0] sw;
    logic [0:0] led;
endinterface

// 2. DRIVER
class blinky_driver extends uvm_driver;
    `uvm_component_utils(blinky_driver)
    virtual blinky_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual blinky_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface must be set");
    endfunction

    task run_phase(uvm_phase phase);
        // Initial OFF
        vif.sw <= 0;
        
        forever begin
            // Scenario A: Switch OFF (Wait 2000ns)
            `uvm_info("DRIVER", ">>> Set Switch = 0 (Expect LED OFF) <<<", UVM_LOW);
            vif.sw <= 0;
            #2000ns; 

            // Scenario B: Switch ON (Wait 5000ns)
            `uvm_info("DRIVER", ">>> Set Switch = 1 (Expect LED BLINK) <<<", UVM_LOW);
            vif.sw <= 1;
            #5000ns;
        end
    endtask
endclass

// 3. MONITOR
class blinky_monitor extends uvm_monitor;
    `uvm_component_utils(blinky_monitor)
    virtual blinky_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual blinky_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface must be set");
    endfunction

    task run_phase(uvm_phase phase);
        logic prev_led = 0;
        forever begin
            @(posedge vif.clk);
            if (vif.led !== prev_led) begin
                `uvm_info("MONITOR", $sformatf("LED Toggled to: %b", vif.led), UVM_LOW);
                prev_led = vif.led;
            end
        end
    endtask
endclass

// 4. AGENT
class blinky_agent extends uvm_agent;
    `uvm_component_utils(blinky_agent)
    blinky_driver    driver;
    blinky_monitor   monitor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = blinky_driver::type_id::create("driver", this);
        monitor = blinky_monitor::type_id::create("monitor", this);
    endfunction
endclass

// 5. TEST
class blinky_test extends uvm_test;
    `uvm_component_utils(blinky_test)
    blinky_agent agent;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = blinky_agent::type_id::create("agent", this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #10000ns; // Run for 10 us total
        phase.drop_objection(this);
    endtask
endclass

// 6. TOP MODULE
module top;
    logic clk;
    
    // 50MHz Clock
    initial begin
        clk = 0;
        forever #10ns clk = ~clk;
    end

    blinky_if vif(clk);

    blinky dut (
        .clk(clk),
        .sw(vif.sw),
        .led(vif.led)
    );

    initial begin
        uvm_config_db#(virtual blinky_if)::set(null, "*", "vif", vif);
        run_test("blinky_test");
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top);
    end
endmodule