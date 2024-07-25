
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_PACKET_SIZE 1024
#define MAX_AUDIO_DATA_SIZE 960

// Define struct VoIPPacket
struct VoIPPacket {
    char header[64];
    char audio_data[MAX_AUDIO_DATA_SIZE];
};

// Function to process VoIP packet
void process_packet(char* raw_data, int data_size) {
    // Create a VoIPPacket struct
    struct VoIPPacket packet;

    // Copy raw_data into packet
    memcpy(packet.header, raw_data, sizeof(packet.header));

    // Print the packet header
    printf("Packet Header: %s\n", packet.header);
}

int main() {
     struct VoIPPacket *packet = malloc(sizeof(struct VoIPPacket));
    int *canary = malloc(sizeof(int));
    *canary = 0xDEADBEEF; // Canary value to detect overflow

    char *oversized_data = malloc(sizeof(struct VoIPPacket) + 10000000000 * sizeof(int));
    memset(oversized_data, 'A', sizeof(struct VoIPPacket) + 10000000000  * sizeof(int));
    strcpy(oversized_data, "VOIP HEADER");

    printf("Before process_packet:\n");
    printf("Canary value: 0x%X\n", *canary);

    printf("Memory addresses:\n");
    printf("packet: %p\n", (void*)packet);
    printf("canary: %p\n", (void*)canary);
    printf("oversized_data: %p\n", (void*)oversized_data);

    process_packet(oversized_data, sizeof(struct VoIPPacket) + sizeof(int));

    printf("\nAfter process_packet:\n");
    printf("Canary value: 0x%X\n", *canary);

    if (*canary != 0xDEADBEEF) {
        printf("Buffer overflow detected! Canary value has been modified.\n");
    } else {
        printf("No buffer overflow detected.\n");
    }

    free(packet);
    free(canary);
    free(oversized_data);
    return 0;
}