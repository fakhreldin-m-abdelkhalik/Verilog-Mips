#include <iostream>
#include <fstream>
#include <string>
#include <map>

using namespace std;

map <string, string> op_code;
map <string, string> function;
map <string, string> registers;

string instructions[1000];		//array of instructions
int i;					//number of instructions

map < string, int > labels;     	//any label in source code and its address

void init_op_code();
void init_function();
void init_registers();
void read_data(ifstream& input);				 //reading data from input file --> filling instructions array
void tokenize(string& s, string tokens[], string delimiters);	 //extract tokens from string (the tokens splitted each by the delimiters passed)
bool is_delimiter(char c, string delimiters);			 //check passed charcter is a delimiter or not
string with_no_first_spaces(string& s);				 //removing any spaces in the begining of the string
void remove_comment(string& s);					 //removing comment from a line if found

int main() {

	init_op_code();
	init_function();
	init_registers();

	ifstream code;
	ofstream myfile;
	myfile.open("example.txt");

	read_data(code);
	for (int j = 0; j < i; j++)
	{
		string st[4];
		tokenize(instructions[j], st, " ,");
		for (int k = 0; k < 4; k++)
		{
			if (k == 0)
			{
				myfile << op_code[st[k]] << endl;
			}
			else if (k == 1)
			{
				myfile << registers[st[k]] << endl;
			}
			else if (k == 2 && st[k].substr(0, 1) == "$")
			{
				myfile << registers[st[k]] << endl;
			}
			else if (k == 3 && st[k].substr(0, 1) == "$")
			{
				myfile << registers[st[k]] << endl;
			}
			else
			{
				myfile << st[k] << endl;
			}
		}
	}

	myfile.close();

	return 0;
}

void read_data(ifstream& input) {
	string s;
	string tokens[5];

	input.open("Assembly code.txt");				//open the source of assembly code file

	if (input.fail()) {
		cout << "failed to open the file." << endl;
		return;
	}

	while (getline(input, s)) {

		if (s[0] != 0) {
			remove_comment(s);
			s = with_no_first_spaces(s);
			tokenize(s, tokens, " ,");					//toknize each line

			if (tokens[0].find(':') != string::npos) {
				labels[tokens[0].substr(0, tokens[0].length() - 1)] = i * 4;
				string ss = with_no_first_spaces(s.substr(tokens[0].length()));
				string str = tokens[0] + ss;
				if (str.length() != tokens[0].length())
					instructions[i++] = ss;
			}
			else
				instructions[i++] = s;
		}

	}
	input.close();									//close the file
}

void tokenize(string& s, string tokens[], string delimiters) {
	string token;
	int n_tokens = 0;
	for (int i = 0; i < s.length(); i++) {
		if (is_delimiter(s[i], delimiters)) {
			tokens[n_tokens++] = token;
			token = "";
			while (is_delimiter(s[i + 1], " ,"))
				i++;
		}
		else
			token += s[i];
	}
	if (!is_delimiter(s[s.length() - 1], " ,"))
		tokens[n_tokens] = token;
}

bool is_delimiter(char c, string delimiters) {
	if (delimiters.find(c) != string::npos)
		return true;
	return false;
}

string with_no_first_spaces(string& s) {
	int i = 0;
	while (s[i++] == ' ');
	return s.substr(i - 1);
}

void remove_comment(string& s) {
	if (s.find('#') != string::npos)
		s = s.substr(0, s.find('#'));
}

void init_op_code()
{
	op_code["add"]  = "000000";
	op_code["sll"]  = "000000";
	op_code["and"]  = "000000";
	op_code["or"]   = "000000";
	op_code["nor"]  = "000000";
	op_code["slt"]  = "000000";
	op_code["jr"]   = "000000";
	op_code["addi"] = "001000";
	op_code["lw"]   = "100011";
	op_code["sw"]   = "101011";
	op_code["andi"] = "001100";
	op_code["ori"]  = "001101";
	op_code["beq"]  = "000100";
	op_code["jal"]  = "000011";

}

void init_function()
{
	function["add"] = "100000";
	function["sll"] = "000000";
	function["and"] = "100100";
	function["or"]  = "100101";
	function["nor"] = "100111";
	function["slt"] = "101010";
	function["jr"]  = "001000";
}

void init_registers()
{
	registers["$0"]  = "00000";
	registers["$at"] = "00001";
	registers["$v0"] = "00010";
	registers["$v1"] = "00011";
	registers["$a0"] = "00100";
	registers["$a1"] = "00101";
	registers["$a2"] = "00110";
	registers["$a3"] = "00111";
	registers["$t0"] = "01000";
	registers["$t1"] = "01001";
	registers["$t2"] = "01010";
	registers["$t3"] = "01011";
	registers["$t4"] = "01100";
	registers["$t5"] = "01101";
	registers["$t6"] = "01110";
	registers["$t7"] = "01111";
	registers["$s0"] = "10000";
	registers["$s1"] = "10001";
	registers["$s2"] = "10010";
	registers["$s3"] = "10011";
	registers["$s4"] = "10100";
	registers["$s5"] = "10101";
	registers["$s6"] = "10110";
	registers["$s7"] = "10111";
	registers["$t8"] = "11000";
	registers["$t9"] = "11001";
	registers["$k0"] = "11010";
	registers["$k1"] = "11011";
	registers["$gp"] = "11100";
	registers["$sp"] = "11101";
	registers["$fp"] = "11110";
	registers["$ra"] = "11111";
}