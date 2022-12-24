module primes (
    
    input wire [3:0] x, // input data (4 bits)
    output reg z        // output. 0-no prime, 1-prime
    );

    /* We use a procedural description for the circuit */
    always @* begin
        /* With the 'case' sentence we can execute a different operation
         * depending on the value of a variable or expression. In our case,
         * it is specially convenient since the output only depends on "x".*/
        case(x)         /* expression to test */
        2:  z = 1;      /* action in case the value is "2" */
        3:  z = 1;      /* etc. */
        5:  z = 1;
        7:  z = 1;
        11: z = 1;
        13: z = 1;
        default: z = 0; /* action in any other case
                         * Note that a combinational circuit should always
                         * generate an output value for any input value, so
                         * the 'default' is necessary in most cases when a
                         * 'case' statement to describe combinational
                         * behavior. */
        endcase
    end

endmodule 

