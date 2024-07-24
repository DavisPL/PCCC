#include <stdio.h>
#include <string.h>

// Function to concatenate src to the end of dest
void concatenate_strings(char* dest, const char* src) {
    // Move dest pointer to the end of the current string
    while (*dest != '\0') {
        dest++;
    }
    // Append src to dest
    while (*src != '\0') {
        *dest = *src;
        dest++;
        src++;
    }
    // Null-terminate the concatenated string
    *dest = '\0';
}

int main() {
    // Create a destination array with enough space for concatenation
   char buffer[10];
    char adjacent_var[10] = "INTACT";
    char* source = "This is a long string that will cause overflow and Let's see what happens!";
    
    strcpy(buffer, "Hi");
    
    printf("Before concatenation:\n");
    printf("buffer: %s\n", buffer);
    printf("adjacent_var: %s\n", adjacent_var);
    
    concatenate_strings(buffer, source);
    
    printf("\nAfter concatenation:\n");
    printf("buffer: %s\n", buffer);
    printf("adjacent_var: %s\n", adjacent_var);
    
    // Print memory contents
    printf("\nMemory contents:\n");
    for (int i = 0; i < 200; i++) {
        printf("%c ", ((char*)buffer)[i]);
    }
    printf("\n");
    

    return 0;
}
