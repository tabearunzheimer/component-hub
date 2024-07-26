{ 
    nfca: { 
        identifier: [4, 35, 122, 44, 33, 2, 137], 
        atqa: [68, 0], 
        maxTransceiveLength: 253, 
        sak: 0, 
        timeout: 618 
    }, 
    mifareultralight: { 
        identifier: [4, 35, 122, 44, 33, 2, 137], 
        maxTransceiveLength: 253, 
        timeout: 618, 
        type: 2 
    }, 
    ndef: { 
        identifier: [4, 35, 122, 44, 33, 2, 137], 
        isWritable: true, 
        maxSize: 492, 
        canMakeReadOnly: 
        true, 
        cachedMessage: { 
            records: [
                { typeNameFormat: 1, 
                    type: [84], 
                    identifier: [], 
                    payload: [2, 101, 110, 73, 110, 118, 101, 110, 116, 111, 114, 121, 32, 77, 97, 110, 97, 103, 101, 109, 101, 110, 116] 
                }, { 
                    typeNameFormat: 1, 
                    type: [84], 
                    "identifier": [], 
                    "payload": [2, 101, 110, 67, 111, 109, 112, 111, 110, 101, 110, 116, 58, 32, 49, 50, 51] 
                }
            ] 
        }, 
        "type": "org.nfcforum.ndef.type2" 
    }
}