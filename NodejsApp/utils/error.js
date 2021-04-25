module.exports = ( errorMessage, customMessage) => {
    return {
        "resultMessage": {
            "msg": errorMessage,
            "problem": customMessage
        },
    };
};