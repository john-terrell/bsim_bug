import PGTypes::*;

import CSRFile::*;
import ExceptionController::*;

import Assert::*;

typedef enum {
    INIT,
    VERIFY_INIT,
    TEST,
    VERIFY_TEST,
    SOFTWARE_INTERRUPT_TEST,
    SOFTWARE_INTERRUPT_VERIFY,
    COMPLETE
} State deriving(Bits, Eq, FShow);

(* synthesize *)
module mkExceptionController_tb(Empty);
    Reg#(State) state <- mkReg(INIT);
    Reg#(Word) counter <- mkReg(0);

    ExceptionController exceptionController <- mkExceptionController;

    Word actualExceptionVector = 'h8000;

    rule init(state == INIT);
        let succeeded <- exceptionController.csrFile.writeWithOffset(TVEC, actualExceptionVector, 0);
        dynamicAssert(succeeded == True, "Attempt to write MTVEC in machine mode should succeed.");
        state <= COMPLETE;
    endrule

    rule complete(state == COMPLETE);
        $display("    PASS");
        $finish();
    endrule
endmodule
