#include <iostream>
#include <stdlib.h>
#include <fstream>
#include <string>
#include <map>
#include <bitset>
#include <sstream>

using namespace std;

#define not_exist(map, key) map.count(key) == 0

string instructions[1000];		//array of instructions
int line_num[1000];
string machine_lines[1000];
int i;					//number of instructions
bool no_errors = true;

map <string, string> op_code;
map <string, string> function;
map <string, string> registers;
map < string, int > labels;     	//any label in source code and its address

void init_op_code();
void init_function();
void init_registers();
void read_data(ifstream& input);				 //reading data from input file --> filling instructions array
void tokenize(string& s, string tokens[], string delimiters);	 //extract tokens from string (the tokens splitted each by the delimiters passed)
bool is_delimiter(char c, string delimiters);			 //check passed charcter is a delimiter or not
string with_no_first_spaces(string& s);				 //removing any spaces in the begining of the string
void remove_comment(string& s);					 //removing comment from a line if found
string intstr_to_binstr(string& n, int length);			 //return a string in a binary representation of integer n, its length equal to the parameter length passed
string binstr_to_hexstr(string& s);				 //converts from binary string to hexadecimal string (32 bit)
string decode(string& s, int j);				 //decoding passed instruction
bool is_int_value(string& s);					 //check if string s contains digits only
bool is_hex_value(string& s);					 //check if string s contains hexa digits only


int main() {

	init_op_code();
	init_function();
	init_registers();

	ifstream code;
	ofstream output;
	ofstream debug;

	output.open("Machine code.txt");
	debug.open("Debug file.txt");

	try {
		read_data(code);		
	}
	catch (exception& e) {
		output << e.what() << endl;
		return 0;
	}

	//writing the machine code into file
	for (int j = 0; j < i; j++) {
		try {
			string ss = binstr_to_hexstr(decode(instructions[j], j));
			machine_lines[j] = ss;
		}
		catch (exception& e) {
			debug << e.what() << endl;
			no_errors = false;
		}
		catch (runtime_error& re) {
			debug << re.what() << endl;
		}
	}

	if (no_errors) {
		for (int j = 0; j < i; j++) {
			output << machine_lines[j] << endl;
		}
	}
	else
		output << "Assembling process failed, please take a look at debug file.." << endl;

	output.close();
	debug.close();

	return 0;
}

void read_data(ifstream& input) {
	string s;
	string file_name;
	string tokens[1000];
	int j = 0;

	cout << "Please enter file name: ";
	cin >> file_name;

	input.open(file_name);				//open the source of assembly code file

	if (input.fail()) {
		throw exception("Failed to open input file.");
	}

	while (getline(input, s)) {
		j++;
		remove_comment(s);
		s = with_no_first_spaces(s);
		if (s[0] != 0) {
			if (s.find("\*") != string::npos) {
				while (getline(input, s) && s.find("*/") == string::npos)
					j++;
				j++;
				continue;
			}
			tokenize(s, tokens, " ,()\t");					//toknize each line

			if (tokens[0].find(':') != string::npos) {
				labels[tokens[0].substr(0, tokens[0].length() - 1)] = i * 4;
				string ss = with_no_first_spaces(s.substr(tokens[0].length()));
				string str = tokens[0] + ss;

				if (str.length() != tokens[0].length()) {
					line_num[i] = j;
					instructions[i++] = ss;
				}
			}
			else if (tokens[1][0] == ':') {
				labels[tokens[0]] = i * 4;
				string ss = with_no_first_spaces(s.substr(s.find(':') + 1));

				if (ss != "") {
					line_num[i] = j;
					instructions[i++] = ss;
				}
			}
			else {
				line_num[i] = j;
				instructions[i++] = s;
			}
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
			while (is_delimiter(s[i + 1], delimiters))
				i++;
		}
		else
			token += s[i];
	}
	if (!is_delimiter(s[s.length() - 1], delimiters))
		tokens[n_tokens] = token;
}

bool is_delimiter(char c, string delimiters) {
	if (delimiters.find(c) != string::npos)
		return true;
	return false;
}

string with_no_first_spaces(string& s) {
	int k = 0;
	while (s[k] == ' ' || s[k] == '\t')
		k++;
	return s.substr(k);
}

void remove_comment(string& s) {
	if (s.find('#') != string::npos)
		s = s.substr(0, s.find('#'));
}

string intstr_to_binstr(string& n, int length) {
	long long num;
	if (n.length() > 1 && n.substr(0, 2) == "0x") {
		if (is_hex_value(n)) {
			stringstream ss;
			ss << hex << n;
			ss >> num;
		}
		else
			throw exception("Wrong hexadecimal format in immediate field");
	}
	else if (is_int_value(n))
		num = atoi(n.c_str());
	else
		throw exception("Wrong decimal format in immediate field.");
	bitset <32> t(num);
	return t.to_string().substr(32 - length);
}

string binstr_to_hexstr(string& s) {
	bitset <32> t(s);
	stringstream ss;
	ss << hex << uppercase << (int) t.to_ulong();
	string x = ss.str();
	int l = x.length();
	for (int j = 0; j < 8 - l; j++)
		x = "0" + x;
	return x;
}

bool is_int_value(string& s) {
	int k = 0;
	if (s[0] == '-')
		k++;
	for (; k < s.length(); k++) {
		if (!isdigit(s[k]))
			return false;
	}
	return true;
}

bool is_hex_value(string& s) {
	int k = 2;
	string tmp = "abcdefABCDEF";
	for (; k < s.length(); k++) {
		if (!isdigit(s[k]) && tmp.find(s[k]) == string::npos)
			return false;
	}
	return true;
}

string decode(string& s , int j) {
	string st[1000];
	string machine_line = "";
	tokenize(s, st, " ,()\t");

	if (st[0] == "add" ||  st[0] == "and" || st[0] == "or" || st[0] == "nor" || st[0] == "slt" ||
		st[0] == "mult" || st[0] == "sub")
	{
		string msg = "";

		for (int k = 0; k < 3; k++) {
			if (not_exist(registers, st[k + 1]))
				msg += "LINE " + to_string(line_num[j]) +": no such \"" + st[k + 1] + "\" register in MIPS\n";
		}

		if (msg != "")
			throw runtime_error(msg);

		machine_line = op_code[st[0]] + registers[st[2]] + registers[st[3]] + registers[st[1]] + "00000" + function[st[0]];
	}
	else if (st[0] == "addi" || st[0] == "andi" || st[0] == "ori" )
	{
		string msg = "";

		for (int k = 0; k < 2; k++) {
			if (not_exist(registers, st[k + 1]))
				msg += "LINE " + to_string(line_num[j]) + ": no such \"" + st[k + 1] + "\" register in MIPS\n";
		}

		if (st[3].length() > 1 && st[3].substr(0, 2) == "0x") {
			if (!is_hex_value(st[3]))
				msg += "LINE " + to_string(line_num[j]) + ": Wrong hexadecimal format in immediate field\n";
		}

		else if (!is_int_value(st[3]))
			msg += "LINE " + to_string(line_num[j]) + ": Wrong decimal format in immediate field\n";

		if (msg != "")
			throw runtime_error(msg);

		machine_line = op_code[st[0]] + registers[st[2]] + registers[st[1]] + intstr_to_binstr(st[3], 16) ;
	}
	else if (st[0] == "beq")
	{
		string msg;

		for (int k = 0; k < 2; k++) {
			if (not_exist(registers, st[k + 1]))
				msg += "LINE " + to_string(line_num[j]) + ": no such \"" + st[k + 1] + "\" register in MIPS\n";
		}

		if (not_exist(labels, st[3]))
			msg += "LINE " + to_string(line_num[j]) + ": there is no such \"" + st[3] + "\" label in assembly code\n";

		if (msg != "")
			throw runtime_error(msg);

		string x = to_string((labels[st[3]] - 4*(j + 1)) / 4);
		machine_line = op_code[st[0]] + registers[st[1]] + registers[st[2]] + intstr_to_binstr(x , 16);
	}
	else if (st[0] == "sw" || st[0] == "lw")
	{
		string msg = "";
		for (int k = 0; k < 3; k += 2) {
			if (not_exist(registers, st[k + 1]))
				msg += "LINE " + to_string(line_num[j]) + ": no such \"" + st[k + 1] + "\" register in MIPS\n";
		}

		if (st[2].length() > 1 && st[2].substr(0, 2) == "0x") {
			if (!is_hex_value(st[2]))
				msg += "LINE " + to_string(line_num[j]) + ": Wrong hexadecimal format in immediate field\n";
		}

		else if (!is_int_value(st[2]))
			msg += "LINE " + to_string(line_num[j]) + ": Wrong decimal format in immediate field\n";

		if (msg != "")
			throw runtime_error(msg);
		machine_line = op_code[st[0]] + registers[st[3]] + registers[st[1]] + intstr_to_binstr(st[2], 16);
	}
	else if (st[0] == "jal")
	{
		if (not_exist(labels, st[1]))
			throw runtime_error("LINE " + to_string(line_num[j]) + ": there is no such \"" + st[1] + "\" label in assembly code\n");
		string x = to_string(labels[st[1]] /4);
		machine_line = op_code[st[0]] + intstr_to_binstr(x, 26);
	}
	else if (st[0] == "jr")
	{
		if (not_exist(registers, st[1]))
			throw runtime_error("LINE " + to_string(line_num[j]) + ": no such \"" + st[1] + "\" register in MIPS\n");
		machine_line = op_code[st[0]] + registers[st[1]] +"000000000000000" + function[st[0]];
	}
	else if (st[0] == "sll" )
	{
		string msg;

		for (int k = 0; k < 2; k++) {
			if (not_exist(registers, st[k + 1]))
				msg += "LINE " + to_string(line_num[j]) + ": no such \"" + st[k + 1] + "\" register in MIPS\n";
		}

		if (st[3].length() > 1 && st[3].substr(0, 2) == "0x") {
			if (!is_hex_value(st[3]))
				msg += "LINE " + to_string(line_num[j]) + ": Wrong hexadecimal format in immediate field\n";
		}

		else if (!is_int_value(st[3]))
			msg += "LINE " + to_string(line_num[j]) + ": Wrong decimal format in immediate field\n";

		if (msg != "")
			throw runtime_error(msg);

		machine_line = op_code[st[0]] + "00000" + registers[st[2]] + registers[st[1]] + intstr_to_binstr(st[3], 5) + function[st[0]];
	}
	else
	{
		throw exception("unsupported MIPS Instruction");
	}

		return machine_line;
}

void init_op_code()
{
	op_code["add"]   = "000000";
	op_code["sub"]   = "000000";
	op_code["mult"]  = "000000";
	op_code["sll"]   = "000000";
	op_code["and"]   = "000000";
	op_code["or"]    = "000000";
	op_code["nor"]   = "000000";
	op_code["slt"]   = "000000";
	op_code["jr"]    = "000000";
	op_code["addi"]  = "001000";
	op_code["lw"]    = "100011";
	op_code["sw"]    = "101011";
	op_code["andi"]  = "001100";
	op_code["ori"]   = "001101";
	op_code["beq"]   = "000100";
	op_code["jal"]   = "000011";

}

void init_function()
{
	function["add"]  = "100000";
	function["sub"]  = "100010";
	function["mult"] = "011000";
	function["sll"]  = "000000";
	function["and"]  = "100100";
	function["or"]   = "100101";
	function["nor"]  = "100111";
	function["slt"]  = "101010";
	function["jr"]   = "001000";
}

void init_registers()
{
	registers["$0"]    = "00000";
	registers["$zero"] = "00000";
	registers["$at"]   = "00001";
	registers["$v0"]   = "00010";
	registers["$v1"]   = "00011";
	registers["$a0"]   = "00100";
	registers["$a1"]   = "00101";
	registers["$a2"]   = "00110";
	registers["$a3"]   = "00111";
	registers["$t0"]   = "01000";
	registers["$t1"]   = "01001";
	registers["$t2"]   = "01010";
	registers["$t3"]   = "01011";
	registers["$t4"]   = "01100";
	registers["$t5"]   = "01101";
	registers["$t6"]   = "01110";
	registers["$t7"]   = "01111";
	registers["$s0"]   = "10000";
	registers["$s1"]   = "10001";
	registers["$s2"]   = "10010";
	registers["$s3"]   = "10011";
	registers["$s4"]   = "10100";
	registers["$s5"]   = "10101";
	registers["$s6"]   = "10110";
	registers["$s7"]   = "10111";
	registers["$t8"]   = "11000";
	registers["$t9"]   = "11001";
	registers["$k0"]   = "11010";
	registers["$k1"]   = "11011";
	registers["$gp"]   = "11100";
	registers["$sp"]   = "11101";
	registers["$fp"]   = "11110";
	registers["$ra"]   = "11111";
}