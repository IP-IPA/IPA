# IPA


# The following addresses need to be added in the memorymap to be able to work with the APIs in the PULP platform

#define ARCHI_DMAIPA_OFFSET              0x00001C00 
#define ARCHI_IPA_OFFSET                 0x00002000  


#define ARCHI_DMAIPA_ADDR                          ( ARCHI_CLUSTER_PERIPHERALS_ADDR + ARCHI_DMAIPA_OFFSET )
#define ARCHI_IPA_ADDR                             ( ARCHI_CLUSTER_PERIPHERALS_ADDR + ARCHI_IPA_OFFSET )

# For the APIs and sample program please refer @
 
https://github.com/IP-IPA/ipa_example.git