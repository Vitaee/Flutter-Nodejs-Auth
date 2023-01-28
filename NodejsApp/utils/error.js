export default ( errorMessage, customMessage) => {
    return {
        "resultMessage": {
            "msg": errorMessage,
            "problem": customMessage
        },
    };
};