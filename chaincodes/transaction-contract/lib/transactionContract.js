'use strict';

const { Contract } = require('fabric-contract-api');

class TransactionContract extends Contract {

    async InitLedger(ctx) {
        const transactions = [
            {
                TransactionID: "TRN000000001",
                SellerID: "BD000000002",
                SellerName: "Jehan Sadik",
                BuyerID: "BD000000001",
                BuyerName: "Minhaj Morshed Chowdhury",
                Items: [
                    {
                        ItemID: "ITEM000001",
                        ItemName: "Potato",
                        ItemType: "Potato Regular",
                        ItemQuantity: 2,
                        ItemUnitPrice: 50,
                        SubTotal: 100
                    },
                    {
                        ItemID: "ITEM000002",
                        ItemName: "Onion",
                        ItemType: "Local Onion",
                        ItemQuantity: 2,
                        ItemUnitPrice: 100,
                        SubTotal: 200
                    }
                ],
                Tax: 6,
                Total: 306,
                PaymentMethod: "Online Banking (SSLCOMMERZ)",
                PaymentStatus: "Paid"
            }
        ];

        for (const transaction of transactions) {
            transaction.docType = 'transaction';
            await ctx.stub.putState(transaction.TransactionID, Buffer.from(JSON.stringify(transaction)));
        }
    }

    async CreateTransaction(ctx, TransactionID, SellerID, SellerName, BuyerID, BuyerName, Items, Tax, Total, PaymentMethod, PaymentStatus) {
        const exists = await this.TransactionExists(ctx, TransactionID);
        if (exists) {
            throw new Error(`The order ${TransactionID} already exists`);
        }

        const ItemsJSON = JSON.parse(Items)
        const TaxFloat = parseFloat(Tax)
        const TotalFloat = parseFloat(Total)

        const transaction = {
            TransactionID, SellerID, SellerName, BuyerID, BuyerName, ItemsJSON, TaxFloat, TotalFloat, PaymentMethod, PaymentStatus
        };

        await ctx.stub.putState(TransactionID, Buffer.from(JSON.stringify(transaction)));
        return JSON.stringify(transaction);
    }

    // ReadTransaction returns the transaction stored in the world state with given id.
    async ReadTransaction(ctx, TransactionID) {
        const transactionJSON = await ctx.stub.getState(TransactionID); // get the transaction from chaincode state
        if (!transactionJSON || transactionJSON.length === 0) {
            throw new Error(`The transaction ${TransactionID} does not exist`);
        }
        return transactionJSON.toString();
    }

    // TransactionExists returns true when transaction with given ID exists in world state.
    async TransactionExists(ctx, TransactionID) {
        const transactionJSON = await ctx.stub.getState(TransactionID);
        return transactionJSON && transactionJSON.length > 0;
    }

    // GetAllTransactions returns all transactions found in the world state.
    async GetAllTransactions(ctx) {
        const allResults = [];
        // range query with empty string for startKey and endKey does an open-ended query of all transactions in the chaincode namespace.
        const iterator = await ctx.stub.getStateByRange('', '');
        let result = await iterator.next();
        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push(record);
            result = await iterator.next();
        }
        return JSON.stringify(allResults);
    }
}

module.exports = TransactionContract;
