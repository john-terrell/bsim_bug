import PGTypes::*;
import Assert::*;

typedef enum {
    MTVEC           = 12'h305     // Machine Trap-Handler base address (MRW)
} CSR deriving(Bits, Eq);

typedef enum {
    TVEC            = 8'h05       // Vector Table
} CSRIndexOffset deriving(Bits, Eq);

interface CSRFile;
    method ActionValue#(Bool) writeWithOffset(CSRIndexOffset offset, Word value, Integer portNumber);
endinterface

module mkCSRFile(CSRFile);
    Reg#(Word)      mtvec       <- mkReg('hC0DEC0DE);
    Reg#(Bit#(2))   curPriv     <- mkReg(pack(PRIVILEGE_LEVEL_MACHINE));

    function CSRIndex getIndex(CSRIndexOffset offset);
        CSRIndex index = 0;
        index[9:8] = curPriv;
        index[7:0] = extend(pack(offset));
        return index;
    endfunction

    function ActionValue#(Bool) writeInternal(CSRIndex index, Word value, Integer portNumber);
        actionvalue
        let result = False;
        $display("CSR Write: $%x = $%x", index, value);
        // Access and write to read-only CSR check.
        if (curPriv >= index[9:8] && index[11:10] != 'b11) begin
            if (index == extend(pack(MTVEC))) begin
                $display("Setting MTVEC to $%0x", value);
                mtvec <= value;
                result = True;
            end
        end else begin
            $display("CSR: Attempt to write to $%0x failed due to access check", index);
        end

        return result;
        endactionvalue
    endfunction

    method ActionValue#(Bool) writeWithOffset(CSRIndexOffset offset, Word value, Integer portNumber);
        let result <- writeInternal(getIndex(offset), value, portNumber);
        return result;
    endmethod
endmodule
