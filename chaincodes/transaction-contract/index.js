'use strict';

const transactionContract = require('./lib/transactionContract');

module.exports.TransactionContract = transactionContract;
module.exports.contracts = [transactionContract];
