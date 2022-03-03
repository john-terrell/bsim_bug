import PGTypes::*;

import CSRFile::*;

import Assert::*;

export ExceptionController(..), mkExceptionController, CSRFile::*;

interface ExceptionController;
    interface CSRFile csrFile;
endinterface

module mkExceptionController(ExceptionController);
    CSRFile csrFileInner <- mkCSRFile;

    interface CSRFile csrFile = csrFileInner;
endmodule
