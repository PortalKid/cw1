/*
FILENAME :	coursework.s

DESCRIPTION :
	Encryptes and decrytpes a message using a cipher table with a private key.

AUTHORS :
	Max Muijzert	studentID: 100197666
	Andy Murray	studentID: 100214063
*/

/*
Code which we're using as psuedocode for our program

public class Main {

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
    public static String remSpaceLower(String string){
        string = string.toLowerCase();
        string = string.replaceAll(" ","");
        return string;
    }
    public static String addXs(int msglen, int keylen, String message){
            int xNeeded = keylen - (msglen % keylen);
            for(int i = 0; i < xNeeded; i++){
                message = message + "x";
        }
        return message;
    }
    public static char[][] makeCipherTable(char[] cPrivateKey, char[] cMessage){
        int lenPrivateKey = cPrivateKey.length;
        int lenMessage = cMessage.length;
        char[][] table = new char[lenPrivateKey][];
        for(int c = 0; c < lenPrivateKey; c++){
            char[] cTemp = new char[lenMessage / lenPrivateKey];
            int aDim1 = c;
            int aDim2 = 0;
            while (aDim1 < lenMessage){
                cTemp[aDim2] = cMessage[aDim1];
                aDim2++;
                aDim1 = aDim1 + lenPrivateKey;
            }
            table[c] = cTemp;
        }
        return table;
    }
    public static int[] alphabetValue(char[] letters, char[] alphabet){
        int lenPrivateKey = letters.length;
        int cLetterValues[] = new int[lenPrivateKey];
        for (int c = 0; c < lenPrivateKey; c++){
            int i= 0;
            while (i < 26){
                if (letters[c] == alphabet[i]){
                    cLetterValues[c] = i;
                    i = 26;
                }
                i++;
            }
        }
        return cLetterValues;
    }
    public static char[][]bubblesort(char[][] table, int[] privateKeyValue) {
        int lenKey = privateKeyValue.length;
        for (int i = 0;i < lenKey - 1;i++){
            boolean swapped = false;
            for (int j = 0; j < lenKey - 1; j++){
                if (privateKeyValue[j] > privateKeyValue[j + 1]) {
                    //swap private key values
                    int tempKeyValue = privateKeyValue[j];
                    privateKeyValue[j] = privateKeyValue[j+1];
                    privateKeyValue[j+1] = tempKeyValue;
                    //swap cipherTable values
                    char[] tempTable = table[j];
                    table[j] = table[j+1];
                    table[j+1] = tempTable;
                    swapped = true;
                }
            }
            if(swapped == false){
                i = lenKey;
            }
        }
    return table;
    }
}

*/
@////////////////////////////////////////////////////////////////////////////////////////
.data
.balign 4
message:	.skip 4000
printf_str: 	.asciz "%s \n"
printf_keylen:	.asciz "%d \n"
printf_msglen:  .asciz "%d \n"

@////////////////////////////////////////////////////////////////////////////////////////
.text
.global main
@main
@desc: This is the main
@param:
@return: 

main:
	@r10 <-- cipherInstruction
	@r9  <-- privateKey
	@r8  <-- privateKeyLen
	@r7  <-- messgeLen
	@r6  <-- message


	PUSH {r4-r10,lr}					@PUSH registers 4-10	AAPCS
	MOV r10, #0						@setting cipherInstruction = 0
	LDR r10,[r1,#4]
	LDR r9,[r1,#8]						@loading memory address of message into register r9

	@read in textfile and store strLen of message
	BL readInFile						@read text file in and removes spaces and punctution

	@lowercase message
	MOV r7, r0						@Move register r0 into r7
	LDR r0,=message						@loading memory address of message into register r6
        BL lower						@branching to lower function

	@print message
	LDR r0,=printf_str					@loading memory address of print f to register r0
	LDR r1,=message						@loading memory address of message to register r1
	BL printf						@run function printf

	@get lengths of privatekey
	MOV r0,r9						@moving privateKey into r0 (passing privateKey as parameter into r0)
	BL strLen						@function strLen:
	MOV r8,r0						@move privatekey to r8

	@print msglen
	MOV r1, r7						@move messageLen to r1 so it can be printed out
	LDR r0,=printf_msglen					@load printf_msglen into r0
	BL printf						@run function printf

	@print keylen
	MOV r1, r8						@move privatekeyLen into r1
	LDR r0,=printf_keylen					@load printf_keylen into r0
	BL printf						@run function printf

	POP {r4-r10,lr}						@POP removes data from stack AAPCS
	BX LR							@end of program

@///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@function: readInFile
@desc: reads in textfile, removes spaces and punctuation. Counts length of trimmed string.
@param: textfile.txt
@return: String message, int strLen
readInFile:

	@r4 <---- i(strLen)
	@r5 <--- message
	PUSH {r4-r10,lr}
	LDR r5,=message						@load message into r5
	MOV r4,#0						@use r4 as i(counter)							@int i =0;

	readInFileLoop:
	BL getchar
	CMP r0,#-1						@checks if char = NUL							@if(char == NUL)
	BEQ readInFileExit					@end of string exit function
	CMP r0,#32						@compared char to space							@if(char == ' ')
	BEQ readInFileLoop					@loops again, doesnt add ' ' to message
	CMP r0,#65						@compares char to A							@if(char == 'A'
	BLT readInFileLoop					@removes punctuation							@if lower than A dont add to message
	STRB r0,[r5,r4]						@stores char in message							@message[i] = char
	ADD r4,r4,#1						@increments the counter							@i = i + 1
	B readInFileLoop					@loops again

	readInFileExit:
		MOV r0,r4					@stores counter(strLen) into r0 so it can be returned			@return strLen
		POP {r4-r10,lr}
		BX lr						@returns to main

@///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
Code for lower function
   string = string.toLowerCase();
*/

@function: lower
@desc: To lower capitals and remove punctuation in message.
@param: message
@return: String lowerMessage
lower:

	@r0 <--- message
	@r4 <--- char
	@r5 <--- i
	@r6 <--- c

	PUSH {r4-r10,lr}					@PUSH data out the registers
	MOV r5, #0						@counter i											@i = 0
	MOV r6, #0						@counter c											@c = 0

	lowerLoop:						@function: lowers str
	LDRB r4, [r0, r5]					@loads message[i] into r4									@char = message[i]
	CMP r4, #0						@compared to null										@if(char == NUL)
	BEQ exitLower						@reached end of string, exits function								@NUL, exitLower()
	CMP r4, #65						@compare to A											@if(char == 'A')
	BLT lowerLoopCounter 					@		  										@less than, lowerLoopCounter()
	CMP r4, #122 						@compare to 'z'											@if(char == 'z')
	BGT lowerLoopCounter					@												@greater than, lowerLoopCounter()
	CMP r4, #90						@compare to 'Z'											@if(char == 'Z'
	ADDLE r4, #32						@lowercases capital char			 						@less then, char = char + 32
	STRB r4, [r0, r6]					@												@message[c] = char
	ADD r6, r6, #1						@increment c											@c = c + 1

	lowerLoopCounter:					@if not a capital
	ADD r5,  #1						@increments i											@i = i + 1
	B lowerLoop						@goes back to loop

		exitLower:					@exits function
		POP {r4-r10, lr}				@POP data back into registers
		BX LR						@go back to main

@////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
Code for strLen function
   int keylen = privateKey.length();
*/

@desc: To obtain the length of the inputted String
@param: message
@return: int StrLen


@r0 <--- parameter for array from main
@r4 <--- char (array at pos)
@r5 <--- i
@r6 <--- array

strLen:
	PUSH {r4-r10,lr}					@data in Register 4-10 is "pushed" to the stack to add more entries
	MOV r6,r0						@r0 holding the array we want to get the length of is put into r6                               @r6=array
	MOV r5, #0						@set counter to 0			                                                        @i=0

	strLenLoop:
	LDRB r4,[r6,r5]						@array at counter loaded to r4		                                                        @char = array[i]
	CMP r4, #0						@Null terminator \0 to see if the string is at the end to end loop                              @if(char==NUL)
	BEQ exitStrLen						@if r4 ==0 go to exitStrLen							                @NUL, exitStrLen
	ADD r5, r5, #1						@Incrementing the i  by one each time a letter has passed through the loop	                @i = i + 1
	B strLenLoop						@Starting the loop again

	@ r0=String length (counter)
	exitStrLen:
                MOV r0,r5                      			@Store strLen into r0 (so it can be used in main)                                               @r0= StrLen
                POP {r4-r10,lr}					@Pop data back into the register
                BX lr                           		@Goes back to main
