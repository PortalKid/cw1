/*
FILENAME :	coursework.s

DESCRIPTION :
	Encryptes and decrytpes a message using a cipher table with a private key.

AUTHORS :
	Max Muijzert
	Andy Murray
*/

/*
java code which we're using as psuedocode for our main

    public static void main(String[] args) {
        char[] alphabet = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
        String privateKey = "dragon";
        String message = "attack at five past four tomorrow ";
        int crytion = 0;
        if (crytion == 0){
            message =remSpaceLower(message);
            int msglen = message.length();
            int keylen = privateKey.length();
            message = addXs(msglen, keylen, message);
            char[] cMessage = message.toCharArray();
            char[] cPrivateKey = privateKey.toCharArray();
            char[][] table = makeCipherTable(cPrivateKey, cMessage);
            int[] cPrivateKeyValue = alphabetValue(cPrivateKey, alphabet);
            char[][] table1 = bubblesort(table, cPrivateKeyValue);
        }else if (crytion == 0){
            //decrytion
        }else{
            System.out.println("Not valid number.");
        }
    }

TO DO
3. strlen function
4. message.strlen

*/
@////////////////////////////////////////////////////////////////////////////////////////
.data
@privateKey: 	.string "dragon"
@message: 	.string "Attack at five past four tomorrow"
.balign 4
message:	.skip 4000


printf_str: 	.asciz "%s \n"
printf_int:	.asciz "%d \n"
@exit_str: 	.asciz "terminting program.\n"
@////////////////////////////////////////////////////////////////////////////////////////
.text
.global main
@desc
@param
@return

main:
	@r10 <-- cipherInstruction
	@r9  <-- privateKey
	@r8  <-- privateKeyLen
	@r7  <-- messgeLen
	@r6  <-- message
	

	PUSH {r4-r10,lr}
	@organise registers
	MOV r10, #0						@setting cipherInstruction = 0
	LDR r10,[r1,#4]
	LDR r9,[r1,#8]						@loading memory address of message into register r9
	BL readInFile
	MOV r7, r0
	LDR r6, =message	@loading memory address of privateKey into register r10

	@removes spaces and lower case from input
	LDR r0,=message		@moving r9 into r0 (passing r9 as parameter into r0 function call)
        BL remSpaceLower	@branching to lowerAndSpacing function
	LDR r0,=printf_str	@loading memory address of print f to register r0
	LDR r1,=message	@loading memory address of message to register r1
	BL printf		@branch with link to print f
	
	@get lengths of string
	@privateKey lne
	MOV r0,r9	@moves private key ready to be passed as parameter
	BL strLen
	MOV r8,r0


	MOV r1,r7
	LDR r0,=printf_int
	BL printf

	

	POP {r4-r10,lr}
	BX LR			@end of program

readInFile:
	PUSH {r4-r10,lr}
	LDR r5,=message
	MOV r4,#0		@int i =0;
	readInFileLoop:
	BL getchar
	CMP r0,#-1		@if(char == EOF)
	BEQ readInFileExit
	CMP r0,#32		@if(char == " ")
	BEQ readInFileLoop
	STRB r0,[r5,r4]		@message[i] = char
	ADD r4,r4,#1
	B readInFileLoop
	
	readInFileExit:
		SUB r4,r4,#1
		MOV r0,r4	@return i which is messageLength
		POP {r4-r10,lr}
		BX lr


@//////////////////////////////////////////////////////////////////////////////////////
.data
.byte 0
@/////////////////////////////////////////////////////////////////////////////////////
.text
@desc : To lower capitals and remove whitespace in String message. 
@param: r5 = 0(counter), r6 = 0(counter)
@return: lowercased string without whitespace
remSpaceLower:
	PUSH {r4-r10,lr}
	MOV r5, #0			@i = 0
	MOV r6, #0			@c = 0

remSpaceLowerLoop:
	LDRB r4, [r0, r5]		@r4 = r0[r5]
	CMP r4, #0			@compared to null
	BEQ exitRemSpaceLower		@if = 0, branch to main
	CMP r4, #65			@compare to space
	BLT remSpaceLowerLoopCounter 	@if letter = space then dont add to array
	CMP r4, #122 			@compare to 'A'
	BGT remSpaceLowerLoopCounter	@lowercase letter | also add to array
	CMP r4, #0x5a			@compare to 'Z'
	ADDLE r4, #0x20			@letter = letter + 32 | lowercase capital character | also add to array
	STRB r4, [r0, r6]
	ADD r6, r6, #1

remSpaceLowerLoopCounter:
				@ if not a capital
	ADD r5,  #1
	B remSpaceLowerLoop

exitRemSpaceLower:
	POP {r4-r10, lr}
	BX LR

@//////////////////////////////////////////////////////////////////////////

@/////////////////////////////////////////////////////////////////////////

/*
   int msglen = message.length();
   int keylen = privateKey.length();
*/
@param: r0 - array you want to get the length of
strLen:
	PUSH {r4-r10,lr}
	MOV r6,r0
        MOV r5, #0                      @i = 0
strLenLoop:
	LDRB r4,[r6,r5]			@array[i]
	CMP r4, #0			@Null terminator \0
	BEQ exitStrLen
	ADD r5, r5, #1
	B strLenLoop

exitStrLen:
	MOV r0,r5
	POP {r4-r10,lr}
	BX lr

/*
    public static String addXs(int msglen, int keylen, String message){
            int xNeeded = keylen - (msglen % keylen);
            for(int i = 0; i < xNeeded; i++){
                message = message + "x";
        }
        return message;
    }
*/

/*
@cleanMyUserInput
@-----
@.data
@-------
@.text
@descrip
@param: String userInput
@return cleanMessage

strlen:
    MOV R1, #0
LOOPP:
    LDRB R2, [R0, R1]
    CMP R2, #0
    ADDNE R1, #1
    BNE LOOPP
    MOV R0, R1
    BX LR
*/
