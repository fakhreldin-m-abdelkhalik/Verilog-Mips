#include <iostream>
#include <fstream>
#include <string>
#include <map>

using namespace std;

string instructions[1000];		//array of instructions
int i;							//number of instructions

map < string, int > labels;     //any label in source code and its address

void read_data(ifstream& input);								 //reading data from input file --> filling instructions array
void tokenize(string& s, string tokens[], string delimiters);	 //extract tokens from string (the tokens splitted each by the delimiters passed)
bool is_delimiter(char c, string delimiters);					 //check passed charcter is a delimiter or not
string with_no_first_spaces(string& s);							//removing any spaces in the begining of the string

int main() {
	ifstream code;
	read_data(code);
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
		s = with_no_first_spaces(s);
		tokenize(s, tokens, " ,");					//toknize each line

		if (tokens[0].find(':') != string::npos) 
			labels[tokens[0]] = (i + 1) * 4;

		else if (s[0] != 0)
			instructions[i++] = s;
	}
	input.close();									//close the file
}

void tokenize(string& s, string tokens[], string delimiters) {
	string token;
	int n_tokens = 0;
	for (int i = 0; i < s.length(); i++) {
		if (is_delimiter(s[i], " ,")) {
			tokens[n_tokens++] = token;
			token = "";
			while (is_delimiter(s[i + 1], " ,"))
				i++;
		}
		else
			token += s[i];
	}
	if (!is_delimiter(s[s.length()-1], " ,"))
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