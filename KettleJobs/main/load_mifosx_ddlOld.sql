-- acc_accounting_rule
CREATE TABLE IF NOT EXISTS `acc_accounting_rule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `office_id` bigint(20) DEFAULT NULL,
  `debit_account_id` bigint(20) DEFAULT NULL,
  `allow_multiple_debits` tinyint(1) NOT NULL DEFAULT '0',
  `credit_account_id` bigint(20) DEFAULT NULL,
  `allow_multiple_credits` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(500) DEFAULT NULL,
  `system_defined` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounting_rule_name_unique` (`name`),
  KEY `FK_acc_accounting_rule_acc_gl_account_debit` (`debit_account_id`),
  KEY `FK_acc_accounting_rule_acc_gl_account_credit` (`credit_account_id`),
  KEY `FK_acc_accounting_rule_m_office` (`office_id`),
  CONSTRAINT `FK_acc_accounting_rule_acc_gl_account_credit` FOREIGN KEY (`credit_account_id`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `FK_acc_accounting_rule_acc_gl_account_debit` FOREIGN KEY (`debit_account_id`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `FK_acc_accounting_rule_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- acc_accounting_rule: ~0 rows (approximately)
/*!40000 ALTER TABLE `acc_accounting_rule` DISABLE KEYS */;
/*!40000 ALTER TABLE `acc_accounting_rule` ENABLE KEYS */;


-- acc_gl_account
CREATE TABLE IF NOT EXISTS `acc_gl_account` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `hierarchy` varchar(50) DEFAULT NULL,
  `gl_code` varchar(45) NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  `manual_journal_entries_allowed` tinyint(1) NOT NULL DEFAULT '1',
  `account_usage` tinyint(1) NOT NULL DEFAULT '2',
  `classification_enum` smallint(5) NOT NULL,
  `tag_id` int(11) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `acc_gl_code` (`gl_code`),
  KEY `FK_ACC_0000000001` (`parent_id`),
  KEY `FKGLACC000000002` (`tag_id`),
  CONSTRAINT `FKGLACC000000002` FOREIGN KEY (`tag_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_ACC_0000000001` FOREIGN KEY (`parent_id`) REFERENCES `acc_gl_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- acc_gl_account: ~0 rows (approximately)
/*!40000 ALTER TABLE `acc_gl_account` DISABLE KEYS */;
/*!40000 ALTER TABLE `acc_gl_account` ENABLE KEYS */;


-- acc_gl_closure
CREATE TABLE IF NOT EXISTS `acc_gl_closure` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `office_id` bigint(20) NOT NULL,
  `closing_date` date NOT NULL,
  `is_deleted` int(20) NOT NULL DEFAULT '0',
  `createdby_id` bigint(20) DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `office_id_closing_date` (`office_id`,`closing_date`),
  KEY `FK_acc_gl_closure_m_office` (`office_id`),
  KEY `FK_acc_gl_closure_m_appuser` (`createdby_id`),
  KEY `FK_acc_gl_closure_m_appuser_2` (`lastmodifiedby_id`),
  CONSTRAINT `FK_acc_gl_closure_m_appuser` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_acc_gl_closure_m_appuser_2` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_acc_gl_closure_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- acc_gl_closure: ~0 rows (approximately)
/*!40000 ALTER TABLE `acc_gl_closure` DISABLE KEYS */;
/*!40000 ALTER TABLE `acc_gl_closure` ENABLE KEYS */;


-- acc_gl_journal_entry
CREATE TABLE IF NOT EXISTS `acc_gl_journal_entry` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` bigint(20) NOT NULL,
  `office_id` bigint(20) NOT NULL,
  `reversal_id` bigint(20) DEFAULT NULL,
  `currency_code` varchar(3) NOT NULL,
  `transaction_id` varchar(50) NOT NULL,
  `loan_transaction_id` bigint(20) DEFAULT NULL,
  `savings_transaction_id` bigint(20) DEFAULT NULL,
  `reversed` tinyint(1) NOT NULL DEFAULT '0',
  `ref_num` varchar(100) DEFAULT NULL,
  `manual_entry` tinyint(1) NOT NULL DEFAULT '0',
  `entry_date` date NOT NULL,
  `type_enum` smallint(5) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `entity_type_enum` smallint(5) DEFAULT NULL,
  `entity_id` bigint(20) DEFAULT NULL,
  `createdby_id` bigint(20) NOT NULL,
  `lastmodifiedby_id` bigint(20) NOT NULL,
  `created_date` datetime NOT NULL,
  `lastmodified_date` datetime NOT NULL,
  `is_running_balance_calculated` tinyint(4) NOT NULL DEFAULT '0',
  `office_running_balance` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `organization_running_balance` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `payment_details_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_acc_gl_journal_entry_m_office` (`office_id`),
  KEY `FK_acc_gl_journal_entry_m_appuser` (`createdby_id`),
  KEY `FK_acc_gl_journal_entry_m_appuser_2` (`lastmodifiedby_id`),
  KEY `FK_acc_gl_journal_entry_acc_gl_journal_entry` (`reversal_id`),
  KEY `FK_acc_gl_journal_entry_acc_gl_account` (`account_id`),
  KEY `FK_acc_gl_journal_entry_m_loan_transaction` (`loan_transaction_id`),
  KEY `FK_acc_gl_journal_entry_m_savings_account_transaction` (`savings_transaction_id`),
  KEY `FK_acc_gl_journal_entry_m_payment_detail` (`payment_details_id`),
  CONSTRAINT `FK_acc_gl_journal_entry_acc_gl_account` FOREIGN KEY (`account_id`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_acc_gl_journal_entry` FOREIGN KEY (`reversal_id`) REFERENCES `acc_gl_journal_entry` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_appuser` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_appuser_2` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_loan_transaction` FOREIGN KEY (`loan_transaction_id`) REFERENCES `m_loan_transaction` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_payment_detail` FOREIGN KEY (`payment_details_id`) REFERENCES `m_payment_detail` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_savings_account_transaction` FOREIGN KEY (`savings_transaction_id`) REFERENCES `m_savings_account_transaction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- acc_gl_journal_entry: ~0 rows (approximately)
/*!40000 ALTER TABLE `acc_gl_journal_entry` DISABLE KEYS */;
/*!40000 ALTER TABLE `acc_gl_journal_entry` ENABLE KEYS */;


-- acc_product_mapping
CREATE TABLE IF NOT EXISTS `acc_product_mapping` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `gl_account_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `product_type` smallint(5) DEFAULT NULL,
  `payment_type` int(11) DEFAULT NULL,
  `charge_id` bigint(20) DEFAULT NULL,
  `financial_account_type` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_acc_product_mapping_m_code_value` (`payment_type`),
  KEY `FK_acc_product_mapping_m_charge` (`charge_id`),
  CONSTRAINT `FK_acc_product_mapping_m_charge` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `FK_acc_product_mapping_m_code_value` FOREIGN KEY (`payment_type`) REFERENCES `m_code_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- acc_product_mapping: ~0 rows (approximately)
/*!40000 ALTER TABLE `acc_product_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `acc_product_mapping` ENABLE KEYS */;


-- acc_rule_tags
CREATE TABLE IF NOT EXISTS `acc_rule_tags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `acc_rule_id` bigint(20) NOT NULL,
  `tag_id` int(11) NOT NULL,
  `acc_type_enum` smallint(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE_ACCOUNT_RULE_TAGS` (`acc_rule_id`,`tag_id`,`acc_type_enum`),
  KEY `FK_acc_accounting_rule_id` (`acc_rule_id`),
  KEY `FK_m_code_value_id` (`tag_id`),
  CONSTRAINT `FK_acc_accounting_rule_id` FOREIGN KEY (`acc_rule_id`) REFERENCES `acc_accounting_rule` (`id`),
  CONSTRAINT `FK_m_code_value_id` FOREIGN KEY (`tag_id`) REFERENCES `m_code_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- acc_rule_tags: ~0 rows (approximately)
/*!40000 ALTER TABLE `acc_rule_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `acc_rule_tags` ENABLE KEYS */;


-- c_cache
CREATE TABLE IF NOT EXISTS `c_cache` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cache_type_enum` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- c_cache: ~1 rows (approximately)
/*!40000 ALTER TABLE `c_cache` DISABLE KEYS */;
INSERT INTO `c_cache` (`id`, `cache_type_enum`) VALUES
	(1, 1);
/*!40000 ALTER TABLE `c_cache` ENABLE KEYS */;


-- c_configuration
CREATE TABLE IF NOT EXISTS `c_configuration` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- c_configuration: ~10 rows (approximately)
/*!40000 ALTER TABLE `c_configuration` DISABLE KEYS */;
INSERT INTO `c_configuration` (`id`, `name`, `value`, `enabled`) VALUES
	(1, 'maker-checker', NULL, 0),
	(4, 'amazon-S3', NULL, 0),
	(5, 'reschedule-future-repayments', NULL, 1),
	(6, 'reschedule-repayments-on-holidays', NULL, 0),
	(7, 'allow-transactions-on-holiday', NULL, 0),
	(8, 'allow-transactions-on-non_workingday', NULL, 0),
	(9, 'constraint_approach_for_datatables', NULL, 0),
	(10, 'penalty-wait-period', 2, 1),
	(11, 'force-password-reset-days', 0, 0),
	(12, 'grace-on-penalty-posting', 0, 1);
/*!40000 ALTER TABLE `c_configuration` ENABLE KEYS */;


-- c_external_service
CREATE TABLE IF NOT EXISTS `c_external_service` (
  `name` varchar(150) NOT NULL,
  `value` varchar(250) DEFAULT NULL,
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- c_external_service: ~3 rows (approximately)
/*!40000 ALTER TABLE `c_external_service` DISABLE KEYS */;
INSERT INTO `c_external_service` (`name`, `value`) VALUES
	('s3_access_key', NULL),
	('s3_bucket_name', NULL),
	('s3_secret_key', NULL);
/*!40000 ALTER TABLE `c_external_service` ENABLE KEYS */;


-- job
CREATE TABLE IF NOT EXISTS `job` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `display_name` varchar(50) NOT NULL,
  `cron_expression` varchar(20) CHARACTER SET latin1 NOT NULL,
  `create_time` datetime NOT NULL,
  `task_priority` smallint(6) NOT NULL DEFAULT '5',
  `group_name` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `previous_run_start_time` datetime DEFAULT NULL,
  `next_run_time` datetime DEFAULT NULL,
  `job_key` varchar(500) DEFAULT NULL,
  `initializing_errorlog` text,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `currently_running` tinyint(1) NOT NULL DEFAULT '0',
  `updates_allowed` tinyint(1) NOT NULL DEFAULT '1',
  `scheduler_group` smallint(2) NOT NULL DEFAULT '0',
  `is_misfired` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- job: ~13 rows (approximately)
/*!40000 ALTER TABLE `job` DISABLE KEYS */;
INSERT INTO `job` (`id`, `name`, `display_name`, `cron_expression`, `create_time`, `task_priority`, `group_name`, `previous_run_start_time`, `next_run_time`, `job_key`, `initializing_errorlog`, `is_active`, `currently_running`, `updates_allowed`, `scheduler_group`, `is_misfired`) VALUES
	(1, 'Update loan Summary', 'Update loan Summary', '0 0 22 1/1 * ? *', '2014-05-06 16:11:19', 5, NULL, NULL, '2014-05-06 22:00:00', 'Update loan SummaryJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0),
	(2, 'Update Loan Arrears Ageing', 'Update Loan Arrears Ageing', '0 1 0 1/1 * ? *', '2014-05-06 16:11:19', 5, NULL, NULL, '2014-05-07 00:01:00', 'Update Loan Arrears AgeingJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0),
	(3, 'Update Loan Paid In Advance', 'Update Loan Paid In Advance', '0 5 0 1/1 * ? *', '2014-05-06 16:11:19', 5, NULL, NULL, '2014-05-07 00:05:00', 'Update Loan Paid In AdvanceJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0),
	(4, 'Apply Annual Fee For Savings', 'Apply Annual Fee For Savings', '0 20 22 1/1 * ? *', '2014-05-06 16:11:19', 5, NULL, NULL, '2014-05-06 22:20:00', 'Apply Annual Fee For SavingsJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0),
	(5, 'Apply Holidays To Loans', 'Apply Holidays To Loans', '0 0 12 * * ?', '2014-05-06 16:11:19', 5, NULL, NULL, '2014-05-07 12:00:00', 'Apply Holidays To LoansJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0),
	(6, 'Post Interest For Savings', 'Post Interest For Savings', '0 0 0 1/1 * ? *', '2014-05-06 16:11:30', 5, NULL, NULL, '2014-05-07 00:00:00', 'Post Interest For SavingsJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0),
	(7, 'Transfer Fee For Loans From Savings', 'Transfer Fee For Loans From Savings', '0 1 0 1/1 * ? *', '2014-05-06 16:11:43', 5, NULL, NULL, '2014-05-07 00:01:00', 'Transfer Fee For Loans From SavingsJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0),
	(8, 'Pay Due Savings Charges', 'Pay Due Savings Charges', '0 0 12 * * ?', '2013-09-23 00:00:00', 5, NULL, NULL, '2014-05-07 12:00:00', 'Pay Due Savings ChargesJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0),
	(9, 'Update Accounting Running Balances', 'Update Accounting Running Balances', '0 1 0 1/1 * ? *', '2014-05-06 16:11:48', 5, NULL, NULL, '2014-05-07 00:01:00', 'Update Accounting Running BalancesJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0),
	(10, 'Execute Standing Instruction', 'Execute Standing Instruction', '0 0 0 1/1 * ? *', '2014-05-06 16:12:15', 5, NULL, NULL, '2014-05-07 00:00:00', 'Execute Standing InstructionJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0),
	(11, 'Add Accrual Transactions', 'Add Accrual Transactions', '0 1 0 1/1 * ? *', '2014-05-06 16:12:15', 5, NULL, NULL, '2014-05-07 00:01:00', 'Add Accrual TransactionsJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0),
	(12, 'Apply penalty to overdue loans', 'Apply penalty to overdue loans', '0 0 0 1/1 * ? *', '2014-05-06 16:12:15', 5, NULL, NULL, '2014-05-07 00:00:00', 'Apply penalty to overdue loansJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0),
	(13, 'Update Non Performing Assets', 'Update Non Performing Assets', '0 0 0 1/1 * ? *', '2014-05-06 16:12:16', 5, NULL, NULL, '2014-05-07 00:00:00', 'Update Non Performing AssetsJobDetail4 _ DEFAULT', NULL, 1, 0, 1, 0, 0);
/*!40000 ALTER TABLE `job` ENABLE KEYS */;


-- job_run_history
CREATE TABLE IF NOT EXISTS `job_run_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `job_id` bigint(20) NOT NULL,
  `version` bigint(20) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `status` varchar(10) CHARACTER SET latin1 NOT NULL,
  `error_message` varchar(500) DEFAULT NULL,
  `trigger_type` varchar(25) NOT NULL,
  `error_log` text,
  PRIMARY KEY (`id`),
  KEY `scheduledjobsFK` (`job_id`),
  CONSTRAINT `scheduledjobsFK` FOREIGN KEY (`job_id`) REFERENCES `job` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- job_run_history: ~0 rows (approximately)
/*!40000 ALTER TABLE `job_run_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_run_history` ENABLE KEYS */;


-- mix_taxonomy
CREATE TABLE IF NOT EXISTS `mix_taxonomy` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `namespace_id` int(11) DEFAULT NULL,
  `dimension` varchar(100) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `need_mapping` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;

-- mix_taxonomy: ~48 rows (approximately)
/*!40000 ALTER TABLE `mix_taxonomy` DISABLE KEYS */;
INSERT INTO `mix_taxonomy` (`id`, `name`, `namespace_id`, `dimension`, `type`, `description`, `need_mapping`) VALUES
	(1, 'AdministrativeExpense', 1, NULL, 3, NULL, 1),
	(2, 'Assets', 3, NULL, 1, 'All outstanding principals due for all outstanding client loans. This includes current, delinquent, and renegotiated loans, but not loans that have been written off. It does not include interest receivable.', 1),
	(3, 'Assets', 3, 'MaturityDimension:LessThanOneYearMember', 1, 'Segmentation based on the life of an asset or liability.', 1),
	(4, 'Assets', 3, 'MaturityDimension:MoreThanOneYearMember', 1, 'Segmentation based on the life of an asset or liability.', 1),
	(5, 'CashAndCashEquivalents', 1, NULL, 1, NULL, 1),
	(6, 'Deposits', 3, NULL, 1, 'The total value of funds placed in an account with an MFI that are payable to a depositor. This item includes any current, checking, or savings accounts that are payable on demand. It also includes time deposits which have a fixed maturity date and compulsory deposits.', 1),
	(7, 'Deposits', 3, 'DepositProductsDimension:CompulsoryMember', 1, 'The value of deposits that an MFI\'s clients are required to  maintain as a condition of an existing or future loan.', NULL),
	(8, 'Deposits', 3, 'DepositProductsDimension:VoluntaryMember', 1, 'The value of deposits that an MFI\'s clients are not required to  maintain as a condition of an existing or future loan.', NULL),
	(9, 'Deposits', 3, 'LocationDimension:RuralMember', 1, 'Located in rural areas. Segmentation based on location.', NULL),
	(10, 'Deposits', 3, 'LocationDimension:UrbanMember', 1, 'Located in urban areas. Segmentation based on location.', NULL),
	(11, 'Deposits', 3, 'MaturityDimension:LessThanOneYearMember', 1, 'Segmentation based on the life of an asset or liability.', NULL),
	(12, 'Deposits', 3, 'MaturityDimension:MoreThanOneYearMember', 1, 'Segmentation based on the life of an asset or liability.', NULL),
	(13, 'EmployeeBenefitsExpense', 1, NULL, 3, NULL, NULL),
	(14, 'Equity', 1, NULL, 1, NULL, NULL),
	(15, 'Expense', 1, NULL, 3, NULL, NULL),
	(16, 'FinancialExpense', 3, NULL, 3, 'All costs All costs incurred in raising funds from third parties, fee expenses from non-financial services, net gains (losses) due to changes in fair value of financial liabilities, impairment losses net of reversals of financial assets other than loan portfolio and net gains (losses) from restatement of financial statements in terms of the measuring unit current at the end of the reporting period.', NULL),
	(17, 'FinancialRevenueOnLoans', 3, NULL, 2, 'Interest and non-interest income generated by the provision of credit services to the clients. Fees and commissions for late payment are also included.', NULL),
	(18, 'ImpairmentLossAllowanceGrossLoanPortfolio', 3, NULL, 2, 'An allowance for the risk of losses in the gross loan portfolio due to default .', NULL),
	(19, 'Liabilities', 1, NULL, 1, NULL, NULL),
	(20, 'Liabilities', 3, 'MaturityDimension:LessThanOneYearMember', 1, 'Segmentation based on the life of an asset or liability.', NULL),
	(21, 'Liabilities', 3, 'MaturityDimension:MoreThanOneYearMember', 1, 'Segmentation based on the life of an asset or liability.', NULL),
	(22, 'LoanPortfolioGross', 3, NULL, 2, 'All outstanding principals due for all outstanding client loans. This includes current, delinquent, and renegotiated loans, but not loans that have been written off. It does not include interest receivable.', NULL),
	(23, 'LoanPortfolioGross', 3, 'CreditProductsDimension:MicroenterpriseMember', 2, 'Loans that finance the production or trade of goods and  services for an individual\'s microenterprise, whether or not the microenterprise is legally registered. Segmentation based on loan product.', NULL),
	(24, 'LoanPortfolioGross', 3, 'DelinquencyDimension:OneMonthOrMoreMember', 2, 'Segmentation based on the principal balance of all loans outstanding that have one or more installments of principal  past due or renegotiated. Segmentation based on the  principal balance of all loans outstanding that have one or  more installments of principal past due or renegotiated.', NULL),
	(25, 'LoanPortfolioGross', 3, 'DelinquencyDimension:ThreeMonthsOrMoreMember', 2, 'Segmentation based on the principal balance of all loans outstanding that have one or more installments of principal  past due or renegotiated.? Segmentation based on the  principal balance of all loans outstanding that have one or  more installments of principal past due or renegotiated.', NULL),
	(26, 'LoanPortfolioGross', 3, 'LocationDimension:RuralMember', 2, 'Located in rural areas. Segmentation based on geographic location.', NULL),
	(27, 'LoanPortfolioGross', 3, 'LocationDimension:UrbanMember', 2, 'Located in urbal areas. Segmentation based on geographic location.', NULL),
	(28, 'LoanPortfolioGross', 3, 'MaturityDimension:LessThanOneYearMember', 2, 'Segmentation based on the life of an asset or liability.', NULL),
	(29, 'LoanPortfolioGross', 3, 'MaturityDimension:MoreThanOneYearMember', 2, 'Segmentation based on the life of an asset or liability.', NULL),
	(30, 'NetLoanLoss', 3, '', 3, 'Referred to the value of delinquency loans written off net of any principal recovery.', NULL),
	(31, 'NetLoanLossProvisionExpense', 3, NULL, 3, 'Represent the net value of loan portfolio impairment loss considering any reversal on impairment loss and any recovery on loans written off recognized as a income during the accounting period.', NULL),
	(32, 'NetOperatingIncome', 3, NULL, 2, 'Total operating revenue less all expenses related to the MFI\'s core financial service operation including total financial expense, impairment loss and operating expense. Donations are excluded.', NULL),
	(33, 'NetOperatingIncomeNetOfTaxExpense', 3, NULL, 3, 'Net operating income reported incorporating the effect of taxes. Taxes include all domestic and foreign taxes which are based on taxable profits, other taxes related to personnel, financial transactions or value-added taxes are not considered in calculation of this value.', NULL),
	(34, 'NumberOfActiveBorrowers', 3, NULL, 0, 'The number of individuals who currently have an outstanding loan balance with the MFI or are primarily responsible for repaying any portion of the gross loan portfolio. Individuals who have multiple loans with an MFI should be counted as a single borrower.', NULL),
	(35, 'NumberOfActiveBorrowers', 3, 'GenderDimension:FemaleMember', 0, 'The number of individuals who currently have an outstanding loan balance with the MFI or are primarily responsible for repaying any portion of the gross loan portfolio. Individuals who have multiple loans with an MFI should be counted as a single borrower.', NULL),
	(36, 'NumberOfBoardMembers', 3, 'GenderDimension:FemaleMember', 0, 'The number of members that comprise the board of directors at the end of the reporting period who are female.', NULL),
	(37, 'NumberOfDepositAccounts', 3, NULL, 0, 'The number of individuals who currently have funds on deposit with the MFI on a voluntary basis; i.e., they are not required to maintain the deposit account to access a loan. This number applies only to deposits held by an MFI, not to those deposits held in other institutions by the MFI\'s clients. The number should be based on the number of individuals rather than the number of groups. A single deposit account may represent multiple depositors.', NULL),
	(38, 'NumberOfDepositors', 3, '', 0, 'The number of deposit accounts, both voluntary and compulsory, opened at the MFI whose balances the institution is liable to repay. The number should be based on the number of individual accounts rather than on the number of groups.', NULL),
	(39, 'NumberOfEmployees', 3, NULL, 0, 'The number of individuals who are actively employed by an entity. This number includes contract employees or advisors who dedicate a substantial portion of their time to the entity, even if they are not on the entity\'s employees roster.', NULL),
	(40, 'NumberOfEmployees', 3, 'GenderDimension:FemaleMember', 0, 'The number of individuals who are actively employed by an entity. This number includes contract employees or advisors who dedicate a substantial portion of their time to the entity, even if they are not on the entity\'s employees roster.', NULL),
	(41, 'NumberOfLoanOfficers', 3, NULL, 0, 'The number of employees whose main activity is to manage a portion of the gross loan portfolio. A loan officer is a staff member of record who is directly responsible for arranging and monitoring client loans.', NULL),
	(42, 'NumberOfLoanOfficers', 3, 'GenderDimension:FemaleMember', 0, 'The number of employees whose main activity is to manage a portion of the gross loan portfolio. A loan officer is a staff member of record who is directly responsible for arranging and monitoring client loans.', NULL),
	(43, 'NumberOfManagers', 3, 'GenderDimension:FemaleMember', 0, 'The number of members that comprise the management of the institution who are female.', NULL),
	(44, 'NumberOfOffices', 3, NULL, 0, 'The number of staffed points of service and administrative sites used to deliver or support the delivery of financial services to microfinance clients.', NULL),
	(45, 'NumberOfOutstandingLoans', 3, NULL, 0, 'The number of loans in the gross loan portfolio. For MFIs using a group lending methodology, the number of loans should refer to the number of individuals receiving loans as part of a group or as part of a group loan.', NULL),
	(46, 'OperatingExpense', 3, NULL, 3, 'Includes expenses not related to financial and credit loss impairment, such as personnel expenses, depreciation, amortization and administrative expenses.', NULL),
	(47, 'OperatingIncome', 3, NULL, 2, 'Includes all financial income and other operating revenue which is generated from non-financial services. Operating income also includes net gains (losses) from holding financial assets (changes on their values during the period and foreign exchange differences). Donations or any revenue not related with an MFI\'s core business of making loans and providing financial services are not considered under this category.', NULL),
	(48, 'WriteOffsOnGrossLoanPortfolio', 3, NULL, 2, 'The value of loans that have been recognized as uncollectible for accounting purposes. A write-off is an accounting procedure that removes the outstanding balance of the loan from the gross loan portfolio and impairment loss allowance. Thus, the write-off does not affect the net loan portfolio, total assets, or any equity account. If the impairment loss allowance is insufficient to cover the amount written off, the excess amount will result in an additional impairment loss on loans recognised in profit or loss of the period.', NULL);
/*!40000 ALTER TABLE `mix_taxonomy` ENABLE KEYS */;


-- mix_taxonomy_mapping
CREATE TABLE IF NOT EXISTS `mix_taxonomy_mapping` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL DEFAULT '',
  `config` varchar(200) DEFAULT NULL,
  `last_update_date` datetime DEFAULT NULL,
  `currency` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- mix_taxonomy_mapping: ~1 rows (approximately)
/*!40000 ALTER TABLE `mix_taxonomy_mapping` DISABLE KEYS */;
INSERT INTO `mix_taxonomy_mapping` (`id`, `identifier`, `config`, `last_update_date`, `currency`) VALUES
	(1, 'default', NULL, NULL, '');
/*!40000 ALTER TABLE `mix_taxonomy_mapping` ENABLE KEYS */;


-- mix_xbrl_namespace
CREATE TABLE IF NOT EXISTS `mix_xbrl_namespace` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `prefix` varchar(20) NOT NULL DEFAULT '',
  `url` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNQUE` (`prefix`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- mix_xbrl_namespace: ~7 rows (approximately)
/*!40000 ALTER TABLE `mix_xbrl_namespace` DISABLE KEYS */;
INSERT INTO `mix_xbrl_namespace` (`id`, `prefix`, `url`) VALUES
	(1, 'ifrs', 'http://xbrl.iasb.org/taxonomy/2009-04-01/ifrs'),
	(2, 'iso4217', 'http://www.xbrl.org/2003/iso4217'),
	(3, 'mix', 'http://www.themix.org/int/fr/ifrs/basi/YYYY-MM-DD/mx-cor'),
	(4, 'xbrldi', 'http://xbrl.org/2006/xbrldi'),
	(5, 'xbrli', 'http://www.xbrl.org/2003/instance'),
	(6, 'link', 'http://www.xbrl.org/2003/linkbase'),
	(7, 'dc-all', 'http://www.themix.org/int/fr/ifrs/basi/2010-08-31/dc-all');
/*!40000 ALTER TABLE `mix_xbrl_namespace` ENABLE KEYS */;


-- m_account_transfer_details
CREATE TABLE IF NOT EXISTS `m_account_transfer_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_office_id` bigint(20) NOT NULL,
  `to_office_id` bigint(20) NOT NULL,
  `from_client_id` bigint(20) DEFAULT NULL,
  `to_client_id` bigint(20) DEFAULT NULL,
  `from_savings_account_id` bigint(20) DEFAULT NULL,
  `to_savings_account_id` bigint(20) DEFAULT NULL,
  `from_loan_account_id` bigint(20) DEFAULT NULL,
  `to_loan_account_id` bigint(20) DEFAULT NULL,
  `transfer_type` smallint(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_account_transfer_details_from_office` (`from_office_id`),
  KEY `FK_m_account_transfer_details_to_office` (`to_office_id`),
  KEY `FK_m_account_transfer_details_from_client` (`from_client_id`),
  KEY `FK_m_account_transfer_details_to_client` (`to_client_id`),
  KEY `FK_m_account_transfer_details_from_savings_account` (`from_savings_account_id`),
  KEY `FK_m_account_transfer_details_to_savings_account` (`to_savings_account_id`),
  KEY `FK_m_account_transfer_details_from_loan_account` (`from_loan_account_id`),
  KEY `FK_m_account_transfer_details_to_loan_account` (`to_loan_account_id`),
  CONSTRAINT `FK_m_account_transfer_details_from_client` FOREIGN KEY (`from_client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_from_loan_account` FOREIGN KEY (`from_loan_account_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_from_office` FOREIGN KEY (`from_office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_from_savings_account` FOREIGN KEY (`from_savings_account_id`) REFERENCES `m_savings_account` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_to_client` FOREIGN KEY (`to_client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_to_loan_account` FOREIGN KEY (`to_loan_account_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_to_office` FOREIGN KEY (`to_office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_to_savings_account` FOREIGN KEY (`to_savings_account_id`) REFERENCES `m_savings_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_account_transfer_details: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_account_transfer_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_account_transfer_details` ENABLE KEYS */;


-- m_account_transfer_standing_instructions
CREATE TABLE IF NOT EXISTS `m_account_transfer_standing_instructions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `account_transfer_details_id` bigint(20) NOT NULL,
  `priority` tinyint(2) NOT NULL,
  `status` tinyint(2) NOT NULL,
  `instruction_type` tinyint(2) NOT NULL,
  `amount` decimal(19,6) DEFAULT NULL,
  `valid_from` date NOT NULL,
  `valid_till` date DEFAULT NULL,
  `recurrence_type` tinyint(1) NOT NULL,
  `recurrence_frequency` smallint(5) DEFAULT NULL,
  `recurrence_interval` smallint(5) DEFAULT NULL,
  `recurrence_on_day` smallint(2) DEFAULT NULL,
  `recurrence_on_month` smallint(2) DEFAULT NULL,
  `last_run_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `FK_m_standing_instructions_account_transfer_details` (`account_transfer_details_id`),
  CONSTRAINT `FK_m_standing_instructions_account_transfer_details` FOREIGN KEY (`account_transfer_details_id`) REFERENCES `m_account_transfer_details` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_account_transfer_standing_instructions: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_account_transfer_standing_instructions` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_account_transfer_standing_instructions` ENABLE KEYS */;


-- m_account_transfer_transaction
CREATE TABLE IF NOT EXISTS `m_account_transfer_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_transfer_details_id` bigint(20) NOT NULL,
  `from_savings_transaction_id` bigint(20) DEFAULT NULL,
  `from_loan_transaction_id` bigint(20) DEFAULT NULL,
  `to_savings_transaction_id` bigint(20) DEFAULT NULL,
  `to_loan_transaction_id` bigint(20) DEFAULT NULL,
  `is_reversed` tinyint(1) NOT NULL,
  `transaction_date` date NOT NULL,
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `amount` decimal(19,6) NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_account_transfer_transaction_from_m_savings_transaction` (`from_savings_transaction_id`),
  KEY `FK_m_account_transfer_transaction_to_m_savings_transaction` (`to_savings_transaction_id`),
  KEY `FK_m_account_transfer_transaction_to_m_loan_transaction` (`to_loan_transaction_id`),
  KEY `FK_m_account_transfer_transaction_from_m_loan_transaction` (`from_loan_transaction_id`),
  KEY `FK_m_account_transfer_transaction_account_detail` (`account_transfer_details_id`),
  CONSTRAINT `FK_m_account_transfer_transaction_account_detail` FOREIGN KEY (`account_transfer_details_id`) REFERENCES `m_account_transfer_details` (`id`),
  CONSTRAINT `FK_m_account_transfer_transaction_from_m_loan_transaction` FOREIGN KEY (`from_loan_transaction_id`) REFERENCES `m_loan_transaction` (`id`),
  CONSTRAINT `FK_m_account_transfer_transaction_from_m_savings_transaction` FOREIGN KEY (`from_savings_transaction_id`) REFERENCES `m_savings_account_transaction` (`id`),
  CONSTRAINT `FK_m_account_transfer_transaction_to_m_loan_transaction` FOREIGN KEY (`to_loan_transaction_id`) REFERENCES `m_loan_transaction` (`id`),
  CONSTRAINT `FK_m_account_transfer_transaction_to_m_savings_transaction` FOREIGN KEY (`to_savings_transaction_id`) REFERENCES `m_savings_account_transaction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_account_transfer_transaction: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_account_transfer_transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_account_transfer_transaction` ENABLE KEYS */;


-- m_appuser
CREATE TABLE IF NOT EXISTS `m_appuser` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `office_id` bigint(20) DEFAULT NULL,
  `staff_id` bigint(20) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  `firstname` varchar(100) NOT NULL,
  `lastname` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `firsttime_login_remaining` bit(1) NOT NULL,
  `nonexpired` bit(1) NOT NULL,
  `nonlocked` bit(1) NOT NULL,
  `nonexpired_credentials` bit(1) NOT NULL,
  `enabled` bit(1) NOT NULL,
  `last_time_password_updated` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_org` (`username`),
  KEY `FKB3D587CE0DD567A` (`office_id`),
  KEY `fk_m_appuser_002x` (`staff_id`),
  KEY `last_time_password_updated` (`last_time_password_updated`),
  CONSTRAINT `FKB3D587CE0DD567A` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `fk_m_appuser_002` FOREIGN KEY (`staff_id`) REFERENCES `m_staff` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- m_appuser: ~1 rows (approximately)
/*!40000 ALTER TABLE `m_appuser` DISABLE KEYS */;
INSERT INTO `m_appuser` (`id`, `is_deleted`, `office_id`, `staff_id`, `username`, `firstname`, `lastname`, `password`, `email`, `firsttime_login_remaining`, `nonexpired`, `nonlocked`, `nonexpired_credentials`, `enabled`, `last_time_password_updated`) VALUES
	(1, 0, 1, NULL, 'mifos', 'App', 'Administrator', '5787039480429368bf94732aacc771cd0a3ea02bcf504ffe1185ab94213bc63a', 'demomfi@mifos.org', b'00000000', b'10000000', b'10000000', b'10000000', b'10000000', '2014-05-06');
/*!40000 ALTER TABLE `m_appuser` ENABLE KEYS */;


-- m_appuser_previous_password
CREATE TABLE IF NOT EXISTS `m_appuser_previous_password` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `removal_date` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `m_appuser_previous_password_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- m_appuser_previous_password: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_appuser_previous_password` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_appuser_previous_password` ENABLE KEYS */;


-- m_appuser_role
CREATE TABLE IF NOT EXISTS `m_appuser_role` (
  `appuser_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  PRIMARY KEY (`appuser_id`,`role_id`),
  KEY `FK7662CE59B4100309` (`appuser_id`),
  KEY `FK7662CE5915CEC7AB` (`role_id`),
  CONSTRAINT `FK7662CE5915CEC7AB` FOREIGN KEY (`role_id`) REFERENCES `m_role` (`id`),
  CONSTRAINT `FK7662CE59B4100309` FOREIGN KEY (`appuser_id`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_appuser_role: ~1 rows (approximately)
/*!40000 ALTER TABLE `m_appuser_role` DISABLE KEYS */;
INSERT INTO `m_appuser_role` (`appuser_id`, `role_id`) VALUES
	(1, 1);
/*!40000 ALTER TABLE `m_appuser_role` ENABLE KEYS */;


-- m_calendar
CREATE TABLE IF NOT EXISTS `m_calendar` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `duration` smallint(6) DEFAULT NULL,
  `calendar_type_enum` smallint(5) NOT NULL,
  `repeating` tinyint(1) NOT NULL DEFAULT '0',
  `recurrence` varchar(100) DEFAULT NULL,
  `remind_by_enum` smallint(5) DEFAULT NULL,
  `first_reminder` smallint(11) DEFAULT NULL,
  `second_reminder` smallint(11) DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_calendar: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_calendar` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_calendar` ENABLE KEYS */;


-- m_calendar_history
CREATE TABLE IF NOT EXISTS `m_calendar_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `calendar_id` bigint(20) NOT NULL,
  `title` varchar(50) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `duration` smallint(6) DEFAULT NULL,
  `calendar_type_enum` smallint(5) NOT NULL,
  `repeating` tinyint(1) NOT NULL DEFAULT '0',
  `recurrence` varchar(100) DEFAULT NULL,
  `remind_by_enum` smallint(5) DEFAULT NULL,
  `first_reminder` smallint(11) DEFAULT NULL,
  `second_reminder` smallint(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_calendar_m_calendar_history` (`calendar_id`),
  CONSTRAINT `FK_m_calendar_m_calendar_history` FOREIGN KEY (`calendar_id`) REFERENCES `m_calendar` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- m_calendar_history: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_calendar_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_calendar_history` ENABLE KEYS */;


-- m_calendar_instance
CREATE TABLE IF NOT EXISTS `m_calendar_instance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `calendar_id` bigint(20) NOT NULL,
  `entity_id` bigint(20) NOT NULL,
  `entity_type_enum` smallint(5) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_calendar_m_calendar_instance` (`calendar_id`),
  CONSTRAINT `FK_m_calendar_m_calendar_instance` FOREIGN KEY (`calendar_id`) REFERENCES `m_calendar` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_calendar_instance: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_calendar_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_calendar_instance` ENABLE KEYS */;


-- m_charge
CREATE TABLE IF NOT EXISTS `m_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `currency_code` varchar(3) NOT NULL,
  `charge_applies_to_enum` smallint(5) NOT NULL,
  `charge_time_enum` smallint(5) NOT NULL,
  `charge_calculation_enum` smallint(5) NOT NULL,
  `charge_payment_mode_enum` smallint(5) DEFAULT NULL,
  `amount` decimal(19,6) NOT NULL,
  `fee_on_day` smallint(5) DEFAULT NULL,
  `fee_interval` smallint(5) DEFAULT NULL,
  `fee_on_month` smallint(5) DEFAULT NULL,
  `is_penalty` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `min_cap` decimal(19,6) DEFAULT NULL,
  `max_cap` decimal(19,6) DEFAULT NULL,
  `fee_frequency` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_charge: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_charge` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_charge` ENABLE KEYS */;


-- m_client
CREATE TABLE IF NOT EXISTS `m_client` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_no` varchar(20) NOT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `status_enum` int(5) NOT NULL DEFAULT '300',
  `activation_date` date DEFAULT NULL,
  `office_joining_date` date DEFAULT NULL,
  `office_id` bigint(20) NOT NULL,
  `transfer_to_office_id` bigint(20) DEFAULT NULL,
  `staff_id` bigint(20) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `middlename` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `fullname` varchar(100) DEFAULT NULL,
  `display_name` varchar(100) NOT NULL,
  `mobile_no` varchar(50) DEFAULT NULL,
  `gender_cv_id` int(11) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `image_id` bigint(20) DEFAULT NULL,
  `closure_reason_cv_id` int(11) DEFAULT NULL,
  `closedon_date` date DEFAULT NULL,
  `submittedon_date` date DEFAULT NULL,
  `submittedon_userid` bigint(20) DEFAULT NULL,
  `activatedon_userid` bigint(20) DEFAULT NULL,
  `closedon_userid` bigint(20) DEFAULT NULL,
  `default_savings_product` bigint(20) DEFAULT NULL,
  `default_savings_account` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_no_UNIQUE` (`account_no`),
  UNIQUE KEY `external_id` (`external_id`),
  UNIQUE KEY `mobile_no_UNIQUE` (`mobile_no`),
  KEY `FKCE00CAB3E0DD567A` (`office_id`),
  KEY `FK_m_client_m_image` (`image_id`),
  KEY `client_staff_id` (`staff_id`),
  KEY `FK_m_client_m_code` (`closure_reason_cv_id`),
  KEY `FK_m_client_m_office` (`transfer_to_office_id`),
  KEY `FK_m_client_m_savings_product` (`default_savings_product`),
  KEY `FK_m_client_m_savings_account` (`default_savings_account`),
  CONSTRAINT `FKCE00CAB3E0DD567A` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_m_client_m_code` FOREIGN KEY (`closure_reason_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_m_client_m_image` FOREIGN KEY (`image_id`) REFERENCES `m_image` (`id`),
  CONSTRAINT `FK_m_client_m_office` FOREIGN KEY (`transfer_to_office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_m_client_m_savings_account` FOREIGN KEY (`default_savings_account`) REFERENCES `m_savings_account` (`id`),
  CONSTRAINT `FK_m_client_m_savings_product` FOREIGN KEY (`default_savings_product`) REFERENCES `m_savings_product` (`id`),
  CONSTRAINT `FK_m_client_m_staff` FOREIGN KEY (`staff_id`) REFERENCES `m_staff` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_client: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_client` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_client` ENABLE KEYS */;


-- m_client_attendance
CREATE TABLE IF NOT EXISTS `m_client_attendance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) NOT NULL DEFAULT '0',
  `meeting_id` bigint(20) NOT NULL,
  `attendance_type_enum` smallint(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_client_meeting_attendance` (`client_id`,`meeting_id`),
  KEY `FK_m_meeting_m_client_attendance` (`meeting_id`),
  CONSTRAINT `FK_m_client_m_client_attendance` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FK_m_meeting_m_client_attendance` FOREIGN KEY (`meeting_id`) REFERENCES `m_meeting` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_client_attendance: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_client_attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_client_attendance` ENABLE KEYS */;


-- m_client_identifier
CREATE TABLE IF NOT EXISTS `m_client_identifier` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) NOT NULL,
  `document_type_id` int(11) NOT NULL,
  `document_key` varchar(50) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_identifier_key` (`document_type_id`,`document_key`),
  UNIQUE KEY `unique_client_identifier` (`client_id`,`document_type_id`),
  KEY `FK_m_client_document_m_client` (`client_id`),
  KEY `FK_m_client_document_m_code_value` (`document_type_id`),
  CONSTRAINT `FK_m_client_document_m_client` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FK_m_client_document_m_code_value` FOREIGN KEY (`document_type_id`) REFERENCES `m_code_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_client_identifier: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_client_identifier` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_client_identifier` ENABLE KEYS */;


-- m_code
CREATE TABLE IF NOT EXISTS `m_code` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code_name` varchar(100) DEFAULT NULL,
  `is_system_defined` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_name` (`code_name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- m_code: ~15 rows (approximately)
/*!40000 ALTER TABLE `m_code` DISABLE KEYS */;
INSERT INTO `m_code` (`id`, `code_name`, `is_system_defined`) VALUES
	(1, 'Customer Identifier', 1),
	(2, 'LoanCollateral', 1),
	(3, 'LoanPurpose', 1),
	(4, 'Gender', 1),
	(5, 'YesNo', 1),
	(6, 'GuarantorRelationship', 1),
	(7, 'AssetAccountTags', 1),
	(8, 'LiabilityAccountTags', 1),
	(9, 'EquityAccountTags', 1),
	(10, 'IncomeAccountTags', 1),
	(11, 'ExpenseAccountTags', 1),
	(12, 'PaymentType', 1),
	(13, 'GROUPROLE', 1),
	(14, 'ClientClosureReason', 1),
	(15, 'GroupClosureReason', 1);
/*!40000 ALTER TABLE `m_code` ENABLE KEYS */;


-- m_code_value
CREATE TABLE IF NOT EXISTS `m_code_value` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code_id` int(11) NOT NULL,
  `code_value` varchar(100) DEFAULT NULL,
  `order_position` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_value` (`code_id`,`code_value`),
  KEY `FKCFCEA42640BE071Z` (`code_id`),
  CONSTRAINT `FKCFCEA42640BE071Z` FOREIGN KEY (`code_id`) REFERENCES `m_code` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- m_code_value: ~9 rows (approximately)
/*!40000 ALTER TABLE `m_code_value` DISABLE KEYS */;
INSERT INTO `m_code_value` (`id`, `code_id`, `code_value`, `order_position`) VALUES
	(1, 1, 'Passport', 1),
	(2, 1, 'Id', 2),
	(3, 1, 'Drivers License', 3),
	(4, 1, 'Any Other Id Type', 4),
	(5, 6, 'Spouse', 0),
	(6, 6, 'Parent', 0),
	(7, 6, 'Sibling', 0),
	(8, 6, 'Business Associate', 0),
	(9, 6, 'Other', 0);
/*!40000 ALTER TABLE `m_code_value` ENABLE KEYS */;


-- m_currency
CREATE TABLE IF NOT EXISTS `m_currency` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL,
  `decimal_places` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `display_symbol` varchar(10) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `internationalized_name_code` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=164 DEFAULT CHARSET=utf8;

-- m_currency: ~163 rows (approximately)
/*!40000 ALTER TABLE `m_currency` DISABLE KEYS */;
INSERT INTO `m_currency` (`id`, `code`, `decimal_places`, `currency_multiplesof`, `display_symbol`, `name`, `internationalized_name_code`) VALUES
	(1, 'AED', 2, NULL, NULL, 'UAE Dirham', 'currency.AED'),
	(2, 'AFN', 2, NULL, NULL, 'Afghanistan Afghani', 'currency.AFN'),
	(3, 'ALL', 2, NULL, NULL, 'Albanian Lek', 'currency.ALL'),
	(4, 'AMD', 2, NULL, NULL, 'Armenian Dram', 'currency.AMD'),
	(5, 'ANG', 2, NULL, NULL, 'Netherlands Antillian Guilder', 'currency.ANG'),
	(6, 'AOA', 2, NULL, NULL, 'Angolan Kwanza', 'currency.AOA'),
	(7, 'ARS', 2, NULL, '$', 'Argentine Peso', 'currency.ARS'),
	(8, 'AUD', 2, NULL, 'A$', 'Australian Dollar', 'currency.AUD'),
	(9, 'AWG', 2, NULL, NULL, 'Aruban Guilder', 'currency.AWG'),
	(10, 'AZM', 2, NULL, NULL, 'Azerbaijanian Manat', 'currency.AZM'),
	(11, 'BAM', 2, NULL, NULL, 'Bosnia and Herzegovina Convertible Marks', 'currency.BAM'),
	(12, 'BBD', 2, NULL, NULL, 'Barbados Dollar', 'currency.BBD'),
	(13, 'BDT', 2, NULL, NULL, 'Bangladesh Taka', 'currency.BDT'),
	(14, 'BGN', 2, NULL, NULL, 'Bulgarian Lev', 'currency.BGN'),
	(15, 'BHD', 3, NULL, NULL, 'Bahraini Dinar', 'currency.BHD'),
	(16, 'BIF', 0, NULL, NULL, 'Burundi Franc', 'currency.BIF'),
	(17, 'BMD', 2, NULL, NULL, 'Bermudian Dollar', 'currency.BMD'),
	(18, 'BND', 2, NULL, 'B$', 'Brunei Dollar', 'currency.BND'),
	(19, 'BOB', 2, NULL, 'Bs.', 'Bolivian Boliviano', 'currency.BOB'),
	(20, 'BRL', 2, NULL, 'R$', 'Brazilian Real', 'currency.BRL'),
	(21, 'BSD', 2, NULL, NULL, 'Bahamian Dollar', 'currency.BSD'),
	(22, 'BTN', 2, NULL, NULL, 'Bhutan Ngultrum', 'currency.BTN'),
	(23, 'BWP', 2, NULL, NULL, 'Botswana Pula', 'currency.BWP'),
	(24, 'BYR', 0, NULL, NULL, 'Belarussian Ruble', 'currency.BYR'),
	(25, 'BZD', 2, NULL, 'BZ$', 'Belize Dollar', 'currency.BZD'),
	(26, 'CAD', 2, NULL, NULL, 'Canadian Dollar', 'currency.CAD'),
	(27, 'CDF', 2, NULL, NULL, 'Franc Congolais', 'currency.CDF'),
	(28, 'CHF', 2, NULL, NULL, 'Swiss Franc', 'currency.CHF'),
	(29, 'CLP', 0, NULL, '$', 'Chilean Peso', 'currency.CLP'),
	(30, 'CNY', 2, NULL, NULL, 'Chinese Yuan Renminbi', 'currency.CNY'),
	(31, 'COP', 2, NULL, '$', 'Colombian Peso', 'currency.COP'),
	(32, 'CRC', 2, NULL, '?', 'Costa Rican Colon', 'currency.CRC'),
	(33, 'CSD', 2, NULL, NULL, 'Serbian Dinar', 'currency.CSD'),
	(34, 'CUP', 2, NULL, '$MN', 'Cuban Peso', 'currency.CUP'),
	(35, 'CVE', 2, NULL, NULL, 'Cape Verde Escudo', 'currency.CVE'),
	(36, 'CYP', 2, NULL, NULL, 'Cyprus Pound', 'currency.CYP'),
	(37, 'CZK', 2, NULL, NULL, 'Czech Koruna', 'currency.CZK'),
	(38, 'DJF', 0, NULL, NULL, 'Djibouti Franc', 'currency.DJF'),
	(39, 'DKK', 2, NULL, NULL, 'Danish Krone', 'currency.DKK'),
	(40, 'DOP', 2, NULL, 'RD$', 'Dominican Peso', 'currency.DOP'),
	(41, 'DZD', 2, NULL, NULL, 'Algerian Dinar', 'currency.DZD'),
	(42, 'EEK', 2, NULL, NULL, 'Estonian Kroon', 'currency.EEK'),
	(43, 'EGP', 2, NULL, NULL, 'Egyptian Pound', 'currency.EGP'),
	(44, 'ERN', 2, NULL, NULL, 'Eritrea Nafka', 'currency.ERN'),
	(45, 'ETB', 2, NULL, NULL, 'Ethiopian Birr', 'currency.ETB'),
	(46, 'EUR', 2, NULL, '€', 'Euro', 'currency.EUR'),
	(47, 'FJD', 2, NULL, NULL, 'Fiji Dollar', 'currency.FJD'),
	(48, 'FKP', 2, NULL, NULL, 'Falkland Islands Pound', 'currency.FKP'),
	(49, 'GBP', 2, NULL, NULL, 'Pound Sterling', 'currency.GBP'),
	(50, 'GEL', 2, NULL, NULL, 'Georgian Lari', 'currency.GEL'),
	(51, 'GHC', 2, NULL, 'GHc', 'Ghana Cedi', 'currency.GHC'),
	(52, 'GIP', 2, NULL, NULL, 'Gibraltar Pound', 'currency.GIP'),
	(53, 'GMD', 2, NULL, NULL, 'Gambian Dalasi', 'currency.GMD'),
	(54, 'GNF', 0, NULL, NULL, 'Guinea Franc', 'currency.GNF'),
	(55, 'GTQ', 2, NULL, 'Q', 'Guatemala Quetzal', 'currency.GTQ'),
	(56, 'GYD', 2, NULL, NULL, 'Guyana Dollar', 'currency.GYD'),
	(57, 'HKD', 2, NULL, NULL, 'Hong Kong Dollar', 'currency.HKD'),
	(58, 'HNL', 2, NULL, 'L', 'Honduras Lempira', 'currency.HNL'),
	(59, 'HRK', 2, NULL, NULL, 'Croatian Kuna', 'currency.HRK'),
	(60, 'HTG', 2, NULL, 'G', 'Haiti Gourde', 'currency.HTG'),
	(61, 'HUF', 2, NULL, NULL, 'Hungarian Forint', 'currency.HUF'),
	(62, 'IDR', 2, NULL, NULL, 'Indonesian Rupiah', 'currency.IDR'),
	(63, 'ILS', 2, NULL, NULL, 'New Israeli Shekel', 'currency.ILS'),
	(64, 'INR', 2, NULL, '₹', 'Indian Rupee', 'currency.INR'),
	(65, 'IQD', 3, NULL, NULL, 'Iraqi Dinar', 'currency.IQD'),
	(66, 'IRR', 2, NULL, NULL, 'Iranian Rial', 'currency.IRR'),
	(67, 'ISK', 0, NULL, NULL, 'Iceland Krona', 'currency.ISK'),
	(68, 'JMD', 2, NULL, NULL, 'Jamaican Dollar', 'currency.JMD'),
	(69, 'JOD', 3, NULL, NULL, 'Jordanian Dinar', 'currency.JOD'),
	(70, 'JPY', 0, NULL, NULL, 'Japanese Yen', 'currency.JPY'),
	(71, 'KES', 2, NULL, 'KSh', 'Kenyan Shilling', 'currency.KES'),
	(72, 'KGS', 2, NULL, NULL, 'Kyrgyzstan Som', 'currency.KGS'),
	(73, 'KHR', 2, NULL, NULL, 'Cambodia Riel', 'currency.KHR'),
	(74, 'KMF', 0, NULL, NULL, 'Comoro Franc', 'currency.KMF'),
	(75, 'KPW', 2, NULL, NULL, 'North Korean Won', 'currency.KPW'),
	(76, 'KRW', 0, NULL, NULL, 'Korean Won', 'currency.KRW'),
	(77, 'KWD', 3, NULL, NULL, 'Kuwaiti Dinar', 'currency.KWD'),
	(78, 'KYD', 2, NULL, NULL, 'Cayman Islands Dollar', 'currency.KYD'),
	(79, 'KZT', 2, NULL, NULL, 'Kazakhstan Tenge', 'currency.KZT'),
	(80, 'LAK', 2, NULL, NULL, 'Lao Kip', 'currency.LAK'),
	(81, 'LBP', 2, NULL, 'L£', 'Lebanese Pound', 'currency.LBP'),
	(82, 'LKR', 2, NULL, NULL, 'Sri Lanka Rupee', 'currency.LKR'),
	(83, 'LRD', 2, NULL, NULL, 'Liberian Dollar', 'currency.LRD'),
	(84, 'LSL', 2, NULL, NULL, 'Lesotho Loti', 'currency.LSL'),
	(85, 'LTL', 2, NULL, NULL, 'Lithuanian Litas', 'currency.LTL'),
	(86, 'LVL', 2, NULL, NULL, 'Latvian Lats', 'currency.LVL'),
	(87, 'LYD', 3, NULL, NULL, 'Libyan Dinar', 'currency.LYD'),
	(88, 'MAD', 2, NULL, NULL, 'Moroccan Dirham', 'currency.MAD'),
	(89, 'MDL', 2, NULL, NULL, 'Moldovan Leu', 'currency.MDL'),
	(90, 'MGA', 2, NULL, NULL, 'Malagasy Ariary', 'currency.MGA'),
	(91, 'MKD', 2, NULL, NULL, 'Macedonian Denar', 'currency.MKD'),
	(92, 'MMK', 2, NULL, 'K', 'Myanmar Kyat', 'currency.MMK'),
	(93, 'MNT', 2, NULL, NULL, 'Mongolian Tugrik', 'currency.MNT'),
	(94, 'MOP', 2, NULL, NULL, 'Macau Pataca', 'currency.MOP'),
	(95, 'MRO', 2, NULL, NULL, 'Mauritania Ouguiya', 'currency.MRO'),
	(96, 'MTL', 2, NULL, NULL, 'Maltese Lira', 'currency.MTL'),
	(97, 'MUR', 2, NULL, NULL, 'Mauritius Rupee', 'currency.MUR'),
	(98, 'MVR', 2, NULL, NULL, 'Maldives Rufiyaa', 'currency.MVR'),
	(99, 'MWK', 2, NULL, NULL, 'Malawi Kwacha', 'currency.MWK'),
	(100, 'MXN', 2, NULL, '$', 'Mexican Peso', 'currency.MXN'),
	(101, 'MYR', 2, NULL, NULL, 'Malaysian Ringgit', 'currency.MYR'),
	(102, 'MZM', 2, NULL, NULL, 'Mozambique Metical', 'currency.MZM'),
	(103, 'NAD', 2, NULL, NULL, 'Namibia Dollar', 'currency.NAD'),
	(104, 'NGN', 2, NULL, NULL, 'Nigerian Naira', 'currency.NGN'),
	(105, 'NIO', 2, NULL, 'C$', 'Nicaragua Cordoba Oro', 'currency.NIO'),
	(106, 'NOK', 2, NULL, NULL, 'Norwegian Krone', 'currency.NOK'),
	(107, 'NPR', 2, NULL, NULL, 'Nepalese Rupee', 'currency.NPR'),
	(108, 'NZD', 2, NULL, NULL, 'New Zealand Dollar', 'currency.NZD'),
	(109, 'OMR', 3, NULL, NULL, 'Rial Omani', 'currency.OMR'),
	(110, 'PAB', 2, NULL, 'B/.', 'Panama Balboa', 'currency.PAB'),
	(111, 'PEN', 2, NULL, 'S/.', 'Peruvian Nuevo Sol', 'currency.PEN'),
	(112, 'PGK', 2, NULL, NULL, 'Papua New Guinea Kina', 'currency.PGK'),
	(113, 'PHP', 2, NULL, NULL, 'Philippine Peso', 'currency.PHP'),
	(114, 'PKR', 2, NULL, NULL, 'Pakistan Rupee', 'currency.PKR'),
	(115, 'PLN', 2, NULL, NULL, 'Polish Zloty', 'currency.PLN'),
	(116, 'PYG', 0, NULL, '?', 'Paraguayan Guarani', 'currency.PYG'),
	(117, 'QAR', 2, NULL, NULL, 'Qatari Rial', 'currency.QAR'),
	(118, 'RON', 2, NULL, NULL, 'Romanian Leu', 'currency.RON'),
	(119, 'RUB', 2, NULL, NULL, 'Russian Ruble', 'currency.RUB'),
	(120, 'RWF', 0, NULL, NULL, 'Rwanda Franc', 'currency.RWF'),
	(121, 'SAR', 2, NULL, NULL, 'Saudi Riyal', 'currency.SAR'),
	(122, 'SBD', 2, NULL, NULL, 'Solomon Islands Dollar', 'currency.SBD'),
	(123, 'SCR', 2, NULL, NULL, 'Seychelles Rupee', 'currency.SCR'),
	(124, 'SDD', 2, NULL, NULL, 'Sudanese Dinar', 'currency.SDD'),
	(125, 'SEK', 2, NULL, NULL, 'Swedish Krona', 'currency.SEK'),
	(126, 'SGD', 2, NULL, NULL, 'Singapore Dollar', 'currency.SGD'),
	(127, 'SHP', 2, NULL, NULL, 'St Helena Pound', 'currency.SHP'),
	(128, 'SIT', 2, NULL, NULL, 'Slovenian Tolar', 'currency.SIT'),
	(129, 'SKK', 2, NULL, NULL, 'Slovak Koruna', 'currency.SKK'),
	(130, 'SLL', 2, NULL, NULL, 'Sierra Leone Leone', 'currency.SLL'),
	(131, 'SOS', 2, NULL, NULL, 'Somali Shilling', 'currency.SOS'),
	(132, 'SRD', 2, NULL, NULL, 'Surinam Dollar', 'currency.SRD'),
	(133, 'STD', 2, NULL, NULL, 'Sao Tome and Principe Dobra', 'currency.STD'),
	(134, 'SVC', 2, NULL, NULL, 'El Salvador Colon', 'currency.SVC'),
	(135, 'SYP', 2, NULL, NULL, 'Syrian Pound', 'currency.SYP'),
	(136, 'SZL', 2, NULL, NULL, 'Swaziland Lilangeni', 'currency.SZL'),
	(137, 'THB', 2, NULL, NULL, 'Thai Baht', 'currency.THB'),
	(138, 'TJS', 2, NULL, NULL, 'Tajik Somoni', 'currency.TJS'),
	(139, 'TMM', 2, NULL, NULL, 'Turkmenistan Manat', 'currency.TMM'),
	(140, 'TND', 3, NULL, 'DT', 'Tunisian Dinar', 'currency.TND'),
	(141, 'TOP', 2, NULL, NULL, 'Tonga Pa\'anga', 'currency.TOP'),
	(142, 'TRY', 2, NULL, NULL, 'Turkish Lira', 'currency.TRY'),
	(143, 'TTD', 2, NULL, NULL, 'Trinidad and Tobago Dollar', 'currency.TTD'),
	(144, 'TWD', 2, NULL, NULL, 'New Taiwan Dollar', 'currency.TWD'),
	(145, 'TZS', 2, NULL, NULL, 'Tanzanian Shilling', 'currency.TZS'),
	(146, 'UAH', 2, NULL, NULL, 'Ukraine Hryvnia', 'currency.UAH'),
	(147, 'UGX', 2, NULL, 'USh', 'Uganda Shilling', 'currency.UGX'),
	(148, 'USD', 2, NULL, '$', 'US Dollar', 'currency.USD'),
	(149, 'UYU', 2, NULL, '$U', 'Peso Uruguayo', 'currency.UYU'),
	(150, 'UZS', 2, NULL, NULL, 'Uzbekistan Sum', 'currency.UZS'),
	(151, 'VEB', 2, NULL, 'Bs.F.', 'Venezuelan Bolivar', 'currency.VEB'),
	(152, 'VND', 2, NULL, NULL, 'Vietnamese Dong', 'currency.VND'),
	(153, 'VUV', 0, NULL, NULL, 'Vanuatu Vatu', 'currency.VUV'),
	(154, 'WST', 2, NULL, NULL, 'Samoa Tala', 'currency.WST'),
	(155, 'XAF', 0, NULL, NULL, 'CFA Franc BEAC', 'currency.XAF'),
	(156, 'XCD', 2, NULL, NULL, 'East Caribbean Dollar', 'currency.XCD'),
	(157, 'XDR', 5, NULL, NULL, 'SDR (Special Drawing Rights)', 'currency.XDR'),
	(158, 'XOF', 0, NULL, 'CFA', 'CFA Franc BCEAO', 'currency.XOF'),
	(159, 'XPF', 0, NULL, NULL, 'CFP Franc', 'currency.XPF'),
	(160, 'YER', 2, NULL, NULL, 'Yemeni Rial', 'currency.YER'),
	(161, 'ZAR', 2, NULL, 'R', 'South African Rand', 'currency.ZAR'),
	(162, 'ZMK', 2, NULL, NULL, 'Zambian Kwacha', 'currency.ZMK'),
	(163, 'ZWD', 2, NULL, NULL, 'Zimbabwe Dollar', 'currency.ZWD');
/*!40000 ALTER TABLE `m_currency` ENABLE KEYS */;


-- m_deposit_account_recurring_detail
CREATE TABLE IF NOT EXISTS `m_deposit_account_recurring_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_id` bigint(20) NOT NULL DEFAULT '0',
  `recurring_deposit_amount` decimal(19,6) DEFAULT NULL,
  `recurring_deposit_type_enum` smallint(5) DEFAULT NULL,
  `recurring_deposit_frequency` int(11) DEFAULT NULL,
  `recurring_deposit_frequency_type_enum` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKDARD00000000000001` (`savings_account_id`),
  CONSTRAINT `FKDARD00000000000001` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_deposit_account_recurring_detail: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_deposit_account_recurring_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_deposit_account_recurring_detail` ENABLE KEYS */;


-- m_deposit_account_term_and_preclosure
CREATE TABLE IF NOT EXISTS `m_deposit_account_term_and_preclosure` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_id` bigint(20) NOT NULL DEFAULT '0',
  `min_deposit_term` int(11) DEFAULT NULL,
  `max_deposit_term` int(11) DEFAULT NULL,
  `min_deposit_term_type_enum` smallint(5) DEFAULT NULL,
  `max_deposit_term_type_enum` smallint(5) DEFAULT NULL,
  `in_multiples_of_deposit_term` int(11) DEFAULT NULL,
  `in_multiples_of_deposit_term_type_enum` smallint(5) DEFAULT NULL,
  `interest_free_period_applicable` smallint(5) DEFAULT NULL,
  `interest_free_from_period` int(11) DEFAULT NULL,
  `interest_free_to_period` int(11) DEFAULT NULL,
  `interest_free_period_frequency_enum` smallint(5) DEFAULT NULL,
  `pre_closure_penal_applicable` smallint(5) DEFAULT NULL,
  `pre_closure_penal_interest` decimal(19,6) DEFAULT NULL,
  `pre_closure_penal_interest_on_enum` smallint(5) DEFAULT NULL,
  `deposit_period` int(11) DEFAULT NULL,
  `deposit_period_frequency_enum` smallint(5) DEFAULT NULL,
  `deposit_amount` decimal(19,6) DEFAULT NULL,
  `maturity_amount` decimal(19,6) DEFAULT NULL,
  `maturity_date` date DEFAULT NULL,
  `on_account_closure_enum` smallint(5) DEFAULT NULL,
  `expected_firstdepositon_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKDATP00000000000001` (`savings_account_id`),
  CONSTRAINT `FKDATP00000000000001` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_deposit_account_term_and_preclosure: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_deposit_account_term_and_preclosure` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_deposit_account_term_and_preclosure` ENABLE KEYS */;


-- m_deposit_product_interest_rate_chart
CREATE TABLE IF NOT EXISTS `m_deposit_product_interest_rate_chart` (
  `deposit_product_id` bigint(20) NOT NULL,
  `interest_rate_chart_id` bigint(20) NOT NULL,
  UNIQUE KEY `deposit_product_id_interest_rate_chart_id` (`deposit_product_id`,`interest_rate_chart_id`),
  KEY `FKDPIRC00000000000002` (`interest_rate_chart_id`),
  CONSTRAINT `FKDPIRC00000000000001` FOREIGN KEY (`deposit_product_id`) REFERENCES `m_savings_product` (`id`),
  CONSTRAINT `FKDPIRC00000000000002` FOREIGN KEY (`interest_rate_chart_id`) REFERENCES `m_interest_rate_chart` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_deposit_product_interest_rate_chart: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_deposit_product_interest_rate_chart` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_deposit_product_interest_rate_chart` ENABLE KEYS */;


-- m_deposit_product_recurring_detail
CREATE TABLE IF NOT EXISTS `m_deposit_product_recurring_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_product_id` bigint(20) NOT NULL DEFAULT '0',
  `recurring_deposit_type_enum` smallint(5) DEFAULT NULL,
  `recurring_deposit_frequency` int(11) DEFAULT NULL,
  `recurring_deposit_frequency_type_enum` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKDPRD00000000000001` (`savings_product_id`),
  CONSTRAINT `FKDPRD00000000000001` FOREIGN KEY (`savings_product_id`) REFERENCES `m_savings_product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_deposit_product_recurring_detail: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_deposit_product_recurring_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_deposit_product_recurring_detail` ENABLE KEYS */;


-- m_deposit_product_term_and_preclosure
CREATE TABLE IF NOT EXISTS `m_deposit_product_term_and_preclosure` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_product_id` bigint(20) NOT NULL DEFAULT '0',
  `min_deposit_term` int(11) DEFAULT NULL,
  `max_deposit_term` int(11) DEFAULT NULL,
  `min_deposit_term_type_enum` smallint(5) DEFAULT NULL,
  `max_deposit_term_type_enum` smallint(5) DEFAULT NULL,
  `in_multiples_of_deposit_term` int(11) DEFAULT NULL,
  `in_multiples_of_deposit_term_type_enum` smallint(5) DEFAULT NULL,
  `interest_free_period_applicable` smallint(5) DEFAULT NULL,
  `interest_free_from_period` int(11) DEFAULT NULL,
  `interest_free_to_period` int(11) DEFAULT NULL,
  `interest_free_period_frequency_enum` smallint(5) DEFAULT NULL,
  `pre_closure_penal_applicable` smallint(5) DEFAULT NULL,
  `pre_closure_penal_interest` decimal(19,6) DEFAULT NULL,
  `pre_closure_penal_interest_on_enum` smallint(5) DEFAULT NULL,
  `min_deposit_amount` decimal(19,6) DEFAULT NULL,
  `max_deposit_amount` decimal(19,6) DEFAULT NULL,
  `deposit_amount` decimal(19,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKDPTP00000000000001` (`savings_product_id`),
  CONSTRAINT `FKDPTP00000000000001` FOREIGN KEY (`savings_product_id`) REFERENCES `m_savings_product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_deposit_product_term_and_preclosure: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_deposit_product_term_and_preclosure` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_deposit_product_term_and_preclosure` ENABLE KEYS */;


-- m_document
CREATE TABLE IF NOT EXISTS `m_document` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `parent_entity_type` varchar(50) NOT NULL,
  `parent_entity_id` int(20) NOT NULL DEFAULT '0',
  `name` varchar(250) NOT NULL,
  `file_name` varchar(250) NOT NULL,
  `size` int(20) DEFAULT '0',
  `type` varchar(500) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `location` varchar(500) NOT NULL DEFAULT '0',
  `storage_type_enum` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_document: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_document` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_document` ENABLE KEYS */;


-- m_fund
CREATE TABLE IF NOT EXISTS `m_fund` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fund_name_org` (`name`),
  UNIQUE KEY `fund_externalid_org` (`external_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_fund: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_fund` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_fund` ENABLE KEYS */;


-- m_group
CREATE TABLE IF NOT EXISTS `m_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `external_id` varchar(100) DEFAULT NULL,
  `status_enum` int(5) NOT NULL DEFAULT '300',
  `activation_date` date DEFAULT NULL,
  `office_id` bigint(20) NOT NULL,
  `staff_id` bigint(20) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `level_id` int(11) NOT NULL,
  `display_name` varchar(100) NOT NULL,
  `hierarchy` varchar(100) DEFAULT NULL,
  `closure_reason_cv_id` int(11) DEFAULT NULL,
  `closedon_date` date DEFAULT NULL,
  `activatedon_userid` bigint(20) DEFAULT NULL,
  `submittedon_date` date DEFAULT NULL,
  `submittedon_userid` bigint(20) DEFAULT NULL,
  `closedon_userid` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`display_name`,`level_id`),
  UNIQUE KEY `external_id` (`external_id`,`level_id`),
  UNIQUE KEY `external_id_UNIQUE` (`external_id`),
  KEY `office_id` (`office_id`),
  KEY `staff_id` (`staff_id`),
  KEY `Parent_Id_reference` (`parent_id`),
  KEY `FK_m_group_level` (`level_id`),
  KEY `FK_m_group_m_code` (`closure_reason_cv_id`),
  CONSTRAINT `FK_m_group_level` FOREIGN KEY (`level_id`) REFERENCES `m_group_level` (`id`),
  CONSTRAINT `FK_m_group_m_code` FOREIGN KEY (`closure_reason_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_m_group_m_staff` FOREIGN KEY (`staff_id`) REFERENCES `m_staff` (`id`),
  CONSTRAINT `m_group_ibfk_1` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `Parent_Id_reference` FOREIGN KEY (`parent_id`) REFERENCES `m_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_group: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_group` ENABLE KEYS */;


-- m_group_client
CREATE TABLE IF NOT EXISTS `m_group_client` (
  `group_id` bigint(20) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  PRIMARY KEY (`group_id`,`client_id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `m_group_client_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`id`),
  CONSTRAINT `m_group_client_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_group_client: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_group_client` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_group_client` ENABLE KEYS */;


-- m_group_level
CREATE TABLE IF NOT EXISTS `m_group_level` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `super_parent` tinyint(1) NOT NULL,
  `level_name` varchar(100) NOT NULL,
  `recursable` tinyint(1) NOT NULL,
  `can_have_clients` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Parent_levelId_reference` (`parent_id`),
  CONSTRAINT `Parent_levelId_reference` FOREIGN KEY (`parent_id`) REFERENCES `m_group_level` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- m_group_level: ~2 rows (approximately)
/*!40000 ALTER TABLE `m_group_level` DISABLE KEYS */;
INSERT INTO `m_group_level` (`id`, `parent_id`, `super_parent`, `level_name`, `recursable`, `can_have_clients`) VALUES
	(1, NULL, 1, 'Center', 1, 0),
	(2, 1, 0, 'Group', 0, 1);
/*!40000 ALTER TABLE `m_group_level` ENABLE KEYS */;


-- m_group_roles
CREATE TABLE IF NOT EXISTS `m_group_roles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL,
  `role_cv_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE_GROUP_ROLES` (`client_id`,`group_id`,`role_cv_id`),
  KEY `FKGroupRoleClientId` (`client_id`),
  KEY `FKGroupRoleGroupId` (`group_id`),
  KEY `FK_grouprole_m_codevalue` (`role_cv_id`),
  CONSTRAINT `FKGroupRoleClientId` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FKGroupRoleGroupId` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`id`),
  CONSTRAINT `FK_grouprole_m_codevalue` FOREIGN KEY (`role_cv_id`) REFERENCES `m_code_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_group_roles: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_group_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_group_roles` ENABLE KEYS */;


-- m_guarantor
CREATE TABLE IF NOT EXISTS `m_guarantor` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `client_reln_cv_id` int(11) DEFAULT NULL,
  `type_enum` smallint(5) NOT NULL,
  `entity_id` bigint(20) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `address_line_1` varchar(500) DEFAULT NULL,
  `address_line_2` varchar(500) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `zip` varchar(20) DEFAULT NULL,
  `house_phone_number` varchar(20) DEFAULT NULL,
  `mobile_number` varchar(20) DEFAULT NULL,
  `comment` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_guarantor_m_loan` (`loan_id`),
  KEY `FK_m_guarantor_m_code_value` (`client_reln_cv_id`),
  CONSTRAINT `FK_m_guarantor_m_code_value` FOREIGN KEY (`client_reln_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_m_guarantor_m_loan` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_guarantor: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_guarantor` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_guarantor` ENABLE KEYS */;


-- m_holiday
CREATE TABLE IF NOT EXISTS `m_holiday` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `from_date` datetime NOT NULL,
  `to_date` datetime NOT NULL,
  `repayments_rescheduled_to` datetime NOT NULL,
  `status_enum` int(5) NOT NULL DEFAULT '100',
  `processed` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `holiday_name` (`name`,`from_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- m_holiday: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_holiday` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_holiday` ENABLE KEYS */;


-- m_holiday_office
CREATE TABLE IF NOT EXISTS `m_holiday_office` (
  `holiday_id` bigint(20) NOT NULL,
  `office_id` bigint(20) NOT NULL,
  PRIMARY KEY (`holiday_id`,`office_id`),
  KEY `m_holiday_id_ibfk_1` (`holiday_id`),
  KEY `m_office_id_ibfk_2` (`office_id`),
  CONSTRAINT `m_holiday_id_ibfk_1` FOREIGN KEY (`holiday_id`) REFERENCES `m_holiday` (`id`),
  CONSTRAINT `m_office_id_ibfk_2` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- m_holiday_office: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_holiday_office` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_holiday_office` ENABLE KEYS */;


-- m_image
CREATE TABLE IF NOT EXISTS `m_image` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `location` varchar(500) DEFAULT NULL,
  `storage_type_enum` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_image: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_image` ENABLE KEYS */;


-- m_interest_rate_chart
CREATE TABLE IF NOT EXISTS `m_interest_rate_chart` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `from_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_interest_rate_chart: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_interest_rate_chart` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_interest_rate_chart` ENABLE KEYS */;


-- m_interest_rate_slab
CREATE TABLE IF NOT EXISTS `m_interest_rate_slab` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `interest_rate_chart_id` bigint(20) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `period_type_enum` smallint(5) NOT NULL DEFAULT '1',
  `from_period` int(11) NOT NULL DEFAULT '0',
  `to_period` int(11) DEFAULT NULL,
  `amount_range_from` decimal(19,6) DEFAULT NULL,
  `amount_range_to` decimal(19,6) DEFAULT NULL,
  `annual_interest_rate` decimal(19,6) NOT NULL,
  `currency_code` varchar(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKIRS00000000000001` (`interest_rate_chart_id`),
  CONSTRAINT `FKIRS00000000000001` FOREIGN KEY (`interest_rate_chart_id`) REFERENCES `m_interest_rate_chart` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_interest_rate_slab: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_interest_rate_slab` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_interest_rate_slab` ENABLE KEYS */;


-- m_loan
CREATE TABLE IF NOT EXISTS `m_loan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_no` varchar(20) NOT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `fund_id` bigint(20) DEFAULT NULL,
  `loan_officer_id` bigint(20) DEFAULT NULL,
  `loanpurpose_cv_id` int(11) DEFAULT NULL,
  `loan_status_id` smallint(5) NOT NULL,
  `loan_type_enum` smallint(5) NOT NULL,
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `principal_amount` decimal(19,6) NOT NULL,
  `approved_principal` decimal(19,6) NOT NULL,
  `arrearstolerance_amount` decimal(19,6) DEFAULT NULL,
  `nominal_interest_rate_per_period` decimal(19,6) NOT NULL,
  `interest_period_frequency_enum` smallint(5) NOT NULL,
  `annual_nominal_interest_rate` decimal(19,6) NOT NULL,
  `interest_method_enum` smallint(5) NOT NULL,
  `interest_calculated_in_period_enum` smallint(5) NOT NULL DEFAULT '1',
  `term_frequency` smallint(5) NOT NULL DEFAULT '0',
  `term_period_frequency_enum` smallint(5) NOT NULL DEFAULT '2',
  `repay_every` smallint(5) NOT NULL,
  `repayment_period_frequency_enum` smallint(5) NOT NULL,
  `number_of_repayments` smallint(5) NOT NULL,
  `grace_on_principal_periods` smallint(5) DEFAULT NULL,
  `grace_on_interest_periods` smallint(5) DEFAULT NULL,
  `grace_interest_free_periods` smallint(5) DEFAULT NULL,
  `amortization_method_enum` smallint(5) NOT NULL,
  `submittedon_date` date DEFAULT NULL,
  `submittedon_userid` bigint(20) DEFAULT NULL,
  `approvedon_date` date DEFAULT NULL,
  `approvedon_userid` bigint(20) DEFAULT NULL,
  `expected_disbursedon_date` date DEFAULT NULL,
  `expected_firstrepaymenton_date` date DEFAULT NULL,
  `interest_calculated_from_date` date DEFAULT NULL,
  `disbursedon_date` date DEFAULT NULL,
  `disbursedon_userid` bigint(20) DEFAULT NULL,
  `expected_maturedon_date` date DEFAULT NULL,
  `maturedon_date` date DEFAULT NULL,
  `closedon_date` date DEFAULT NULL,
  `closedon_userid` bigint(20) DEFAULT NULL,
  `total_charges_due_at_disbursement_derived` decimal(19,6) DEFAULT NULL,
  `principal_disbursed_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `principal_repaid_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `principal_writtenoff_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `principal_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_charged_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_repaid_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_waived_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_writtenoff_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_charged_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_repaid_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_waived_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_writtenoff_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_charged_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_repaid_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_waived_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_writtenoff_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_expected_repayment_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_repayment_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_expected_costofloan_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_costofloan_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_waived_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_writtenoff_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_overpaid_derived` decimal(19,6) DEFAULT NULL,
  `rejectedon_date` date DEFAULT NULL,
  `rejectedon_userid` bigint(20) DEFAULT NULL,
  `rescheduledon_date` date DEFAULT NULL,
  `withdrawnon_date` date DEFAULT NULL,
  `withdrawnon_userid` bigint(20) DEFAULT NULL,
  `writtenoffon_date` date DEFAULT NULL,
  `loan_transaction_strategy_id` bigint(20) DEFAULT NULL,
  `sync_disbursement_with_meeting` tinyint(1) DEFAULT NULL,
  `loan_counter` smallint(6) DEFAULT NULL,
  `loan_product_counter` smallint(6) DEFAULT NULL,
  `fixed_emi_amount` decimal(19,6) DEFAULT NULL,
  `max_outstanding_loan_balance` decimal(19,6) DEFAULT NULL,
  `grace_on_arrears_ageing` smallint(5) DEFAULT NULL,
  `is_npa` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `loan_account_no_UNIQUE` (`account_no`),
  UNIQUE KEY `loan_externalid_UNIQUE` (`external_id`),
  KEY `FKB6F935D87179A0CB` (`client_id`),
  KEY `FKB6F935D8C8D4B434` (`product_id`),
  KEY `FK7C885877240145` (`fund_id`),
  KEY `FK_loan_ltp_strategy` (`loan_transaction_strategy_id`),
  KEY `FK_m_loan_m_staff` (`loan_officer_id`),
  KEY `group_id` (`group_id`),
  KEY `FK_m_loanpurpose_codevalue` (`loanpurpose_cv_id`),
  KEY `FK_submittedon_userid` (`submittedon_userid`),
  KEY `FK_approvedon_userid` (`approvedon_userid`),
  KEY `FK_rejectedon_userid` (`rejectedon_userid`),
  KEY `FK_withdrawnon_userid` (`withdrawnon_userid`),
  KEY `FK_disbursedon_userid` (`disbursedon_userid`),
  KEY `FK_closedon_userid` (`closedon_userid`),
  KEY `fk_m_group_client_001_idx` (`group_id`,`client_id`),
  CONSTRAINT `FK7C885877240145` FOREIGN KEY (`fund_id`) REFERENCES `m_fund` (`id`),
  CONSTRAINT `FKB6F935D87179A0CB` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FKB6F935D8C8D4B434` FOREIGN KEY (`product_id`) REFERENCES `m_product_loan` (`id`),
  CONSTRAINT `FK_approvedon_userid` FOREIGN KEY (`approvedon_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_closedon_userid` FOREIGN KEY (`closedon_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_disbursedon_userid` FOREIGN KEY (`disbursedon_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_loan_ltp_strategy` FOREIGN KEY (`loan_transaction_strategy_id`) REFERENCES `ref_loan_transaction_processing_strategy` (`id`),
  CONSTRAINT `fk_m_group_client_001` FOREIGN KEY (`group_id`, `client_id`) REFERENCES `m_group_client` (`group_id`, `client_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_m_loanpurpose_codevalue` FOREIGN KEY (`loanpurpose_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_m_loan_m_staff` FOREIGN KEY (`loan_officer_id`) REFERENCES `m_staff` (`id`),
  CONSTRAINT `FK_rejectedon_userid` FOREIGN KEY (`rejectedon_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_submittedon_userid` FOREIGN KEY (`submittedon_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_withdrawnon_userid` FOREIGN KEY (`withdrawnon_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_loan_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan` ENABLE KEYS */;


-- m_loan_arrears_aging
CREATE TABLE IF NOT EXISTS `m_loan_arrears_aging` (
  `loan_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `principal_overdue_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_overdue_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_overdue_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_overdue_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_overdue_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `overdue_since_date_derived` date DEFAULT NULL,
  PRIMARY KEY (`loan_id`),
  CONSTRAINT `m_loan_arrears_aging_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan_arrears_aging: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan_arrears_aging` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan_arrears_aging` ENABLE KEYS */;


-- m_loan_charge
CREATE TABLE IF NOT EXISTS `m_loan_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `charge_id` bigint(20) NOT NULL,
  `is_penalty` tinyint(1) NOT NULL DEFAULT '0',
  `charge_time_enum` smallint(5) NOT NULL,
  `due_for_collection_as_of_date` date DEFAULT NULL,
  `charge_calculation_enum` smallint(5) NOT NULL,
  `charge_payment_mode_enum` smallint(5) NOT NULL DEFAULT '0',
  `calculation_percentage` decimal(19,6) DEFAULT NULL,
  `calculation_on_amount` decimal(19,6) DEFAULT NULL,
  `charge_amount_or_percentage` decimal(19,6) DEFAULT NULL,
  `amount` decimal(19,6) NOT NULL,
  `amount_paid_derived` decimal(19,6) DEFAULT NULL,
  `amount_waived_derived` decimal(19,6) DEFAULT NULL,
  `amount_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `amount_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `is_paid_derived` tinyint(1) NOT NULL DEFAULT '0',
  `waived` tinyint(1) NOT NULL DEFAULT '0',
  `min_cap` decimal(19,6) DEFAULT NULL,
  `max_cap` decimal(19,6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `charge_id` (`charge_id`),
  KEY `m_loan_charge_ibfk_2` (`loan_id`),
  CONSTRAINT `m_loan_charge_ibfk_1` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `m_loan_charge_ibfk_2` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan_charge: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan_charge` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan_charge` ENABLE KEYS */;


-- m_loan_charge_paid_by
CREATE TABLE IF NOT EXISTS `m_loan_charge_paid_by` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_transaction_id` bigint(20) NOT NULL,
  `loan_charge_id` bigint(20) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK__m_loan_transaction` (`loan_transaction_id`),
  KEY `FK__m_loan_charge` (`loan_charge_id`),
  CONSTRAINT `FK__m_loan_charge` FOREIGN KEY (`loan_charge_id`) REFERENCES `m_loan_charge` (`id`),
  CONSTRAINT `FK__m_loan_transaction` FOREIGN KEY (`loan_transaction_id`) REFERENCES `m_loan_transaction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan_charge_paid_by: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan_charge_paid_by` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan_charge_paid_by` ENABLE KEYS */;


-- m_loan_collateral
CREATE TABLE IF NOT EXISTS `m_loan_collateral` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `type_cv_id` int(11) NOT NULL,
  `value` decimal(19,6) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_collateral_m_loan` (`loan_id`),
  KEY `FK_collateral_code_value` (`type_cv_id`),
  CONSTRAINT `FK_collateral_m_loan` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `FK_collateral_code_value` FOREIGN KEY (`type_cv_id`) REFERENCES `m_code_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan_collateral: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan_collateral` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan_collateral` ENABLE KEYS */;


-- m_loan_disbursement_detail
CREATE TABLE IF NOT EXISTS `m_loan_disbursement_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `expected_disburse_date` datetime NOT NULL,
  `disbursedon_date` datetime DEFAULT NULL,
  `principal` decimal(19,6) NOT NULL,
  `approved_principal` decimal(19,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_loan_disbursement_detail_loan_id` (`loan_id`),
  CONSTRAINT `FK_loan_disbursement_detail_loan_id` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan_disbursement_detail: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan_disbursement_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan_disbursement_detail` ENABLE KEYS */;


-- m_loan_installment_charge
CREATE TABLE IF NOT EXISTS `m_loan_installment_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_charge_id` bigint(20) NOT NULL,
  `loan_schedule_id` bigint(20) NOT NULL,
  `due_date` date DEFAULT NULL,
  `amount` decimal(19,6) NOT NULL,
  `amount_paid_derived` decimal(19,6) DEFAULT NULL,
  `amount_waived_derived` decimal(19,6) DEFAULT NULL,
  `amount_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `amount_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `is_paid_derived` tinyint(1) NOT NULL DEFAULT '0',
  `waived` tinyint(1) NOT NULL DEFAULT '0',
  `amount_through_charge_payment` decimal(19,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_loan_charge_id_charge_schedule` (`loan_charge_id`),
  KEY `FK_loan_schedule_id_charge_schedule` (`loan_schedule_id`),
  CONSTRAINT `FK_loan_charge_id_charge_schedule` FOREIGN KEY (`loan_charge_id`) REFERENCES `m_loan_charge` (`id`),
  CONSTRAINT `FK_loan_schedule_id_charge_schedule` FOREIGN KEY (`loan_schedule_id`) REFERENCES `m_loan_repayment_schedule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan_installment_charge: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan_installment_charge` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan_installment_charge` ENABLE KEYS */;


-- m_loan_officer_assignment_history
CREATE TABLE IF NOT EXISTS `m_loan_officer_assignment_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `loan_officer_id` bigint(20) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_m_loan_officer_assignment_history_0001` (`loan_id`),
  KEY `fk_m_loan_officer_assignment_history_0002` (`loan_officer_id`),
  CONSTRAINT `fk_m_loan_officer_assignment_history_0001` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `fk_m_loan_officer_assignment_history_0002` FOREIGN KEY (`loan_officer_id`) REFERENCES `m_staff` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan_officer_assignment_history: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan_officer_assignment_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan_officer_assignment_history` ENABLE KEYS */;


-- m_loan_overdue_installment_charge
CREATE TABLE IF NOT EXISTS `m_loan_overdue_installment_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_charge_id` bigint(20) NOT NULL,
  `loan_schedule_id` bigint(20) NOT NULL,
  `frequency_number` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_loan_overdue_installment_charge_m_loan_charge` (`loan_charge_id`),
  KEY `FK_m_loan_overdue_installment_charge_m_loan_repayment_schedule` (`loan_schedule_id`),
  CONSTRAINT `FK_m_loan_overdue_installment_charge_m_loan_charge` FOREIGN KEY (`loan_charge_id`) REFERENCES `m_loan_charge` (`id`),
  CONSTRAINT `FK_m_loan_overdue_installment_charge_m_loan_repayment_schedule` FOREIGN KEY (`loan_schedule_id`) REFERENCES `m_loan_repayment_schedule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan_overdue_installment_charge: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan_overdue_installment_charge` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan_overdue_installment_charge` ENABLE KEYS */;


-- m_loan_paid_in_advance
CREATE TABLE IF NOT EXISTS `m_loan_paid_in_advance` (
  `loan_id` bigint(20) NOT NULL,
  `principal_in_advance_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_in_advance_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_in_advance_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_in_advance_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_in_advance_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  PRIMARY KEY (`loan_id`),
  CONSTRAINT `m_loan_paid_in_advance_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan_paid_in_advance: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan_paid_in_advance` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan_paid_in_advance` ENABLE KEYS */;


-- m_loan_repayment_schedule
CREATE TABLE IF NOT EXISTS `m_loan_repayment_schedule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `fromdate` date DEFAULT NULL,
  `duedate` date NOT NULL,
  `installment` smallint(5) NOT NULL,
  `principal_amount` decimal(19,6) DEFAULT NULL,
  `principal_completed_derived` decimal(19,6) DEFAULT NULL,
  `principal_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `interest_amount` decimal(19,6) DEFAULT NULL,
  `interest_completed_derived` decimal(19,6) DEFAULT NULL,
  `interest_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `interest_waived_derived` decimal(19,6) DEFAULT NULL,
  `accrual_interest_derived` decimal(19,6) DEFAULT NULL,
  `fee_charges_amount` decimal(19,6) DEFAULT NULL,
  `fee_charges_completed_derived` decimal(19,6) DEFAULT NULL,
  `fee_charges_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `fee_charges_waived_derived` decimal(19,6) DEFAULT NULL,
  `accrual_fee_charges_derived` decimal(19,6) DEFAULT NULL,
  `penalty_charges_amount` decimal(19,6) DEFAULT NULL,
  `penalty_charges_completed_derived` decimal(19,6) DEFAULT NULL,
  `penalty_charges_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `penalty_charges_waived_derived` decimal(19,6) DEFAULT NULL,
  `accrual_penalty_charges_derived` decimal(19,6) DEFAULT NULL,
  `total_paid_in_advance_derived` decimal(19,6) DEFAULT NULL,
  `total_paid_late_derived` decimal(19,6) DEFAULT NULL,
  `completed_derived` bit(1) NOT NULL,
  `obligations_met_on_date` date DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK488B92AA40BE0710` (`loan_id`),
  CONSTRAINT `FK488B92AA40BE0710` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan_repayment_schedule: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan_repayment_schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan_repayment_schedule` ENABLE KEYS */;


-- m_loan_term_variations
CREATE TABLE IF NOT EXISTS `m_loan_term_variations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `term_type` smallint(2) NOT NULL,
  `applicable_from` date NOT NULL,
  `term_value` decimal(19,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_loan_id_m_loan_id` (`loan_id`),
  CONSTRAINT `FK_loan_id_m_loan_id` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan_term_variations: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan_term_variations` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan_term_variations` ENABLE KEYS */;


-- m_loan_transaction
CREATE TABLE IF NOT EXISTS `m_loan_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `office_id` bigint(20) NOT NULL,
  `payment_detail_id` bigint(20) DEFAULT NULL,
  `is_reversed` tinyint(1) NOT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `transaction_type_enum` smallint(5) NOT NULL,
  `transaction_date` date NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `principal_portion_derived` decimal(19,6) DEFAULT NULL,
  `interest_portion_derived` decimal(19,6) DEFAULT NULL,
  `fee_charges_portion_derived` decimal(19,6) DEFAULT NULL,
  `penalty_charges_portion_derived` decimal(19,6) DEFAULT NULL,
  `overpayment_portion_derived` decimal(19,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `external_id_UNIQUE` (`external_id`),
  KEY `FKCFCEA42640BE0710` (`loan_id`),
  KEY `FK_m_loan_transaction_m_payment_detail` (`payment_detail_id`),
  KEY `FK_m_loan_transaction_m_office` (`office_id`),
  CONSTRAINT `FKCFCEA42640BE0710` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `FK_m_loan_transaction_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_m_loan_transaction_m_payment_detail` FOREIGN KEY (`payment_detail_id`) REFERENCES `m_payment_detail` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_loan_transaction: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_loan_transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_loan_transaction` ENABLE KEYS */;


-- m_meeting
CREATE TABLE IF NOT EXISTS `m_meeting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `calendar_instance_id` bigint(20) NOT NULL,
  `meeting_date` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_calendar_instance_id_meeting_date` (`calendar_instance_id`,`meeting_date`),
  CONSTRAINT `FK_m_calendar_instance_m_meeting` FOREIGN KEY (`calendar_instance_id`) REFERENCES `m_calendar_instance` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- m_meeting: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_meeting` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_meeting` ENABLE KEYS */;


-- m_note
CREATE TABLE IF NOT EXISTS `m_note` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL,
  `loan_id` bigint(20) DEFAULT NULL,
  `loan_transaction_id` bigint(20) DEFAULT NULL,
  `savings_account_id` bigint(20) DEFAULT NULL,
  `savings_account_transaction_id` bigint(20) DEFAULT NULL,
  `note_type_enum` smallint(5) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7C9708924D26803` (`loan_transaction_id`),
  KEY `FK7C97089541F0A56` (`createdby_id`),
  KEY `FK7C970897179A0CB` (`client_id`),
  KEY `FK_m_note_m_group` (`group_id`),
  KEY `FK7C970898F889C3F` (`lastmodifiedby_id`),
  KEY `FK7C9708940BE0710` (`loan_id`),
  KEY `FK_savings_account_id` (`savings_account_id`),
  CONSTRAINT `FK_savings_account_id` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK7C9708924D26803` FOREIGN KEY (`loan_transaction_id`) REFERENCES `m_loan_transaction` (`id`),
  CONSTRAINT `FK7C9708940BE0710` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `FK7C97089541F0A56` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK7C970897179A0CB` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FK7C970898F889C3F` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_m_note_m_group` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_note: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_note` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_note` ENABLE KEYS */;


-- m_office
CREATE TABLE IF NOT EXISTS `m_office` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) DEFAULT NULL,
  `hierarchy` varchar(100) DEFAULT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `opening_date` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_org` (`name`),
  UNIQUE KEY `externalid_org` (`external_id`),
  KEY `FK2291C477E2551DCC` (`parent_id`),
  CONSTRAINT `FK2291C477E2551DCC` FOREIGN KEY (`parent_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- m_office: ~1 rows (approximately)
/*!40000 ALTER TABLE `m_office` DISABLE KEYS */;
INSERT INTO `m_office` (`id`, `parent_id`, `hierarchy`, `external_id`, `name`, `opening_date`) VALUES
	(1, NULL, '.', '1', 'Head Office', '2009-01-01');
/*!40000 ALTER TABLE `m_office` ENABLE KEYS */;


-- m_office_transaction
CREATE TABLE IF NOT EXISTS `m_office_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_office_id` bigint(20) DEFAULT NULL,
  `to_office_id` bigint(20) DEFAULT NULL,
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` int(11) NOT NULL,
  `transaction_amount` decimal(19,6) NOT NULL,
  `transaction_date` date NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1E37728B93C6C1B6` (`to_office_id`),
  KEY `FK1E37728B783C5C25` (`from_office_id`),
  CONSTRAINT `FK1E37728B783C5C25` FOREIGN KEY (`from_office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK1E37728B93C6C1B6` FOREIGN KEY (`to_office_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_office_transaction: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_office_transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_office_transaction` ENABLE KEYS */;


-- m_organisation_currency
CREATE TABLE IF NOT EXISTS `m_organisation_currency` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL,
  `decimal_places` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `display_symbol` varchar(10) DEFAULT NULL,
  `internationalized_name_code` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- m_organisation_currency: ~1 rows (approximately)
/*!40000 ALTER TABLE `m_organisation_currency` DISABLE KEYS */;
INSERT INTO `m_organisation_currency` (`id`, `code`, `decimal_places`, `currency_multiplesof`, `name`, `display_symbol`, `internationalized_name_code`) VALUES
	(21, 'USD', 2, NULL, 'US Dollar', '$', 'currency.USD');
/*!40000 ALTER TABLE `m_organisation_currency` ENABLE KEYS */;


-- m_payment_detail
CREATE TABLE IF NOT EXISTS `m_payment_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `payment_type_cv_id` int(11) DEFAULT NULL,
  `account_number` varchar(100) DEFAULT NULL,
  `check_number` varchar(100) DEFAULT NULL,
  `receipt_number` varchar(100) DEFAULT NULL,
  `bank_number` varchar(100) DEFAULT NULL,
  `routing_code` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_payment_detail_m_code_value` (`payment_type_cv_id`),
  CONSTRAINT `FK_m_payment_detail_m_code_value` FOREIGN KEY (`payment_type_cv_id`) REFERENCES `m_code_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_payment_detail: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_payment_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_payment_detail` ENABLE KEYS */;


-- m_permission
CREATE TABLE IF NOT EXISTS `m_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `grouping` varchar(45) DEFAULT NULL,
  `code` varchar(100) NOT NULL,
  `entity_name` varchar(100) DEFAULT NULL,
  `action_name` varchar(100) DEFAULT NULL,
  `can_maker_checker` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=541 DEFAULT CHARSET=utf8;

-- m_permission: ~585 rows (approximately)
/*!40000 ALTER TABLE `m_permission` DISABLE KEYS */;
INSERT INTO `m_permission` (`id`, `grouping`, `code`, `entity_name`, `action_name`, `can_maker_checker`) VALUES
	(1, 'special', 'ALL_FUNCTIONS', NULL, NULL, 0),
	(2, 'special', 'ALL_FUNCTIONS_READ', NULL, NULL, 0),
	(3, 'special', 'CHECKER_SUPER_USER', NULL, NULL, 0),
	(4, 'special', 'REPORTING_SUPER_USER', NULL, NULL, 0),
	(5, 'authorisation', 'READ_PERMISSION', 'PERMISSION', 'READ', 0),
	(6, 'authorisation', 'PERMISSIONS_ROLE', 'ROLE', 'PERMISSIONS', 0),
	(7, 'authorisation', 'CREATE_ROLE', 'ROLE', 'CREATE', 0),
	(8, 'authorisation', 'CREATE_ROLE_CHECKER', 'ROLE', 'CREATE', 0),
	(9, 'authorisation', 'READ_ROLE', 'ROLE', 'READ', 0),
	(10, 'authorisation', 'UPDATE_ROLE', 'ROLE', 'UPDATE', 0),
	(11, 'authorisation', 'UPDATE_ROLE_CHECKER', 'ROLE', 'UPDATE', 0),
	(12, 'authorisation', 'DELETE_ROLE', 'ROLE', 'DELETE', 0),
	(13, 'authorisation', 'DELETE_ROLE_CHECKER', 'ROLE', 'DELETE', 0),
	(14, 'authorisation', 'CREATE_USER', 'USER', 'CREATE', 0),
	(15, 'authorisation', 'CREATE_USER_CHECKER', 'USER', 'CREATE', 0),
	(16, 'authorisation', 'READ_USER', 'USER', 'READ', 0),
	(17, 'authorisation', 'UPDATE_USER', 'USER', 'UPDATE', 0),
	(18, 'authorisation', 'UPDATE_USER_CHECKER', 'USER', 'UPDATE', 0),
	(19, 'authorisation', 'DELETE_USER', 'USER', 'DELETE', 0),
	(20, 'authorisation', 'DELETE_USER_CHECKER', 'USER', 'DELETE', 0),
	(21, 'configuration', 'READ_CONFIGURATION', 'CONFIGURATION', 'READ', 0),
	(22, 'configuration', 'UPDATE_CONFIGURATION', 'CONFIGURATION', 'UPDATE', 0),
	(23, 'configuration', 'UPDATE_CONFIGURATION_CHECKER', 'CONFIGURATION', 'UPDATE', 0),
	(24, 'configuration', 'READ_CODE', 'CODE', 'READ', 0),
	(25, 'configuration', 'CREATE_CODE', 'CODE', 'CREATE', 0),
	(26, 'configuration', 'CREATE_CODE_CHECKER', 'CODE', 'CREATE', 0),
	(27, 'configuration', 'UPDATE_CODE', 'CODE', 'UPDATE', 0),
	(28, 'configuration', 'UPDATE_CODE_CHECKER', 'CODE', 'UPDATE', 0),
	(29, 'configuration', 'DELETE_CODE', 'CODE', 'DELETE', 0),
	(30, 'configuration', 'DELETE_CODE_CHECKER', 'CODE', 'DELETE', 0),
	(31, 'configuration', 'READ_CODEVALUE', 'CODEVALUE', 'READ', 0),
	(32, 'configuration', 'CREATE_CODEVALUE', 'CODEVALUE', 'CREATE', 0),
	(33, 'configuration', 'CREATE_CODEVALUE_CHECKER', 'CODEVALUE', 'CREATE', 0),
	(34, 'configuration', 'UPDATE_CODEVALUE', 'CODEVALUE', 'UPDATE', 0),
	(35, 'configuration', 'UPDATE_CODEVALUE_CHECKER', 'CODEVALUE', 'UPDATE', 0),
	(36, 'configuration', 'DELETE_CODEVALUE', 'CODEVALUE', 'DELETE', 0),
	(37, 'configuration', 'DELETE_CODEVALUE_CHECKER', 'CODEVALUE', 'DELETE', 0),
	(38, 'configuration', 'READ_CURRENCY', 'CURRENCY', 'READ', 0),
	(39, 'configuration', 'UPDATE_CURRENCY', 'CURRENCY', 'UPDATE', 0),
	(40, 'configuration', 'UPDATE_CURRENCY_CHECKER', 'CURRENCY', 'UPDATE', 0),
	(41, 'configuration', 'UPDATE_PERMISSION', 'PERMISSION', 'UPDATE', 0),
	(42, 'configuration', 'UPDATE_PERMISSION_CHECKER', 'PERMISSION', 'UPDATE', 0),
	(43, 'configuration', 'READ_DATATABLE', 'DATATABLE', 'READ', 0),
	(44, 'configuration', 'REGISTER_DATATABLE', 'DATATABLE', 'REGISTER', 0),
	(45, 'configuration', 'REGISTER_DATATABLE_CHECKER', 'DATATABLE', 'REGISTER', 0),
	(46, 'configuration', 'DEREGISTER_DATATABLE', 'DATATABLE', 'DEREGISTER', 0),
	(47, 'configuration', 'DEREGISTER_DATATABLE_CHECKER', 'DATATABLE', 'DEREGISTER', 0),
	(48, 'configuration', 'READ_AUDIT', 'AUDIT', 'READ', 0),
	(49, 'configuration', 'CREATE_CALENDAR', 'CALENDAR', 'CREATE', 0),
	(50, 'configuration', 'READ_CALENDAR', 'CALENDAR', 'READ', 0),
	(51, 'configuration', 'UPDATE_CALENDAR', 'CALENDAR', 'UPDATE', 0),
	(52, 'configuration', 'DELETE_CALENDAR', 'CALENDAR', 'DELETE', 0),
	(53, 'configuration', 'CREATE_CALENDAR_CHECKER', 'CALENDAR', 'CREATE', 0),
	(54, 'configuration', 'UPDATE_CALENDAR_CHECKER', 'CALENDAR', 'UPDATE', 0),
	(55, 'configuration', 'DELETE_CALENDAR_CHECKER', 'CALENDAR', 'DELETE', 0),
	(57, 'organisation', 'READ_CHARGE', 'CHARGE', 'READ', 0),
	(58, 'organisation', 'CREATE_CHARGE', 'CHARGE', 'CREATE', 0),
	(59, 'organisation', 'CREATE_CHARGE_CHECKER', 'CHARGE', 'CREATE', 0),
	(60, 'organisation', 'UPDATE_CHARGE', 'CHARGE', 'UPDATE', 0),
	(61, 'organisation', 'UPDATE_CHARGE_CHECKER', 'CHARGE', 'UPDATE', 0),
	(62, 'organisation', 'DELETE_CHARGE', 'CHARGE', 'DELETE', 0),
	(63, 'organisation', 'DELETE_CHARGE_CHECKER', 'CHARGE', 'DELETE', 0),
	(64, 'organisation', 'READ_FUND', 'FUND', 'READ', 0),
	(65, 'organisation', 'CREATE_FUND', 'FUND', 'CREATE', 0),
	(66, 'organisation', 'CREATE_FUND_CHECKER', 'FUND', 'CREATE', 0),
	(67, 'organisation', 'UPDATE_FUND', 'FUND', 'UPDATE', 0),
	(68, 'organisation', 'UPDATE_FUND_CHECKER', 'FUND', 'UPDATE', 0),
	(69, 'organisation', 'DELETE_FUND', 'FUND', 'DELETE', 0),
	(70, 'organisation', 'DELETE_FUND_CHECKER', 'FUND', 'DELETE', 0),
	(71, 'organisation', 'READ_LOANPRODUCT', 'LOANPRODUCT', 'READ', 0),
	(72, 'organisation', 'CREATE_LOANPRODUCT', 'LOANPRODUCT', 'CREATE', 0),
	(73, 'organisation', 'CREATE_LOANPRODUCT_CHECKER', 'LOANPRODUCT', 'CREATE', 0),
	(74, 'organisation', 'UPDATE_LOANPRODUCT', 'LOANPRODUCT', 'UPDATE', 0),
	(75, 'organisation', 'UPDATE_LOANPRODUCT_CHECKER', 'LOANPRODUCT', 'UPDATE', 0),
	(76, 'organisation', 'DELETE_LOANPRODUCT', 'LOANPRODUCT', 'DELETE', 0),
	(77, 'organisation', 'DELETE_LOANPRODUCT_CHECKER', 'LOANPRODUCT', 'DELETE', 0),
	(78, 'organisation', 'READ_OFFICE', 'OFFICE', 'READ', 0),
	(79, 'organisation', 'CREATE_OFFICE', 'OFFICE', 'CREATE', 0),
	(80, 'organisation', 'CREATE_OFFICE_CHECKER', 'OFFICE', 'CREATE', 0),
	(81, 'organisation', 'UPDATE_OFFICE', 'OFFICE', 'UPDATE', 0),
	(82, 'organisation', 'UPDATE_OFFICE_CHECKER', 'OFFICE', 'UPDATE', 0),
	(83, 'organisation', 'READ_OFFICETRANSACTION', 'OFFICETRANSACTION', 'READ', 0),
	(84, 'organisation', 'DELETE_OFFICE_CHECKER', 'OFFICE', 'DELETE', 0),
	(85, 'organisation', 'CREATE_OFFICETRANSACTION', 'OFFICETRANSACTION', 'CREATE', 0),
	(86, 'organisation', 'CREATE_OFFICETRANSACTION_CHECKER', 'OFFICETRANSACTION', 'CREATE', 0),
	(87, 'organisation', 'DELETE_OFFICETRANSACTION', 'OFFICETRANSACTION', 'DELETE', 0),
	(88, 'organisation', 'DELETE_OFFICETRANSACTION_CHECKER', 'OFFICETRANSACTION', 'DELETE', 0),
	(89, 'organisation', 'READ_STAFF', 'STAFF', 'READ', 0),
	(90, 'organisation', 'CREATE_STAFF', 'STAFF', 'CREATE', 0),
	(91, 'organisation', 'CREATE_STAFF_CHECKER', 'STAFF', 'CREATE', 0),
	(92, 'organisation', 'UPDATE_STAFF', 'STAFF', 'UPDATE', 0),
	(93, 'organisation', 'UPDATE_STAFF_CHECKER', 'STAFF', 'UPDATE', 0),
	(94, 'organisation', 'DELETE_STAFF', 'STAFF', 'DELETE', 0),
	(95, 'organisation', 'DELETE_STAFF_CHECKER', 'STAFF', 'DELETE', 0),
	(96, 'organisation', 'READ_SAVINGSPRODUCT', 'SAVINGSPRODUCT', 'READ', 0),
	(97, 'organisation', 'CREATE_SAVINGSPRODUCT', 'SAVINGSPRODUCT', 'CREATE', 0),
	(98, 'organisation', 'CREATE_SAVINGSPRODUCT_CHECKER', 'SAVINGSPRODUCT', 'CREATE', 0),
	(99, 'organisation', 'UPDATE_SAVINGSPRODUCT', 'SAVINGSPRODUCT', 'UPDATE', 0),
	(100, 'organisation', 'UPDATE_SAVINGSPRODUCT_CHECKER', 'SAVINGSPRODUCT', 'UPDATE', 0),
	(101, 'organisation', 'DELETE_SAVINGSPRODUCT', 'SAVINGSPRODUCT', 'DELETE', 0),
	(102, 'organisation', 'DELETE_SAVINGSPRODUCT_CHECKER', 'SAVINGSPRODUCT', 'DELETE', 0),
	(103, 'portfolio', 'READ_LOAN', 'LOAN', 'READ', 0),
	(104, 'portfolio', 'CREATE_LOAN', 'LOAN', 'CREATE', 0),
	(105, 'portfolio', 'CREATE_LOAN_CHECKER', 'LOAN', 'CREATE', 0),
	(106, 'portfolio', 'UPDATE_LOAN', 'LOAN', 'UPDATE', 0),
	(107, 'portfolio', 'UPDATE_LOAN_CHECKER', 'LOAN', 'UPDATE', 0),
	(108, 'portfolio', 'DELETE_LOAN', 'LOAN', 'DELETE', 0),
	(109, 'portfolio', 'DELETE_LOAN_CHECKER', 'LOAN', 'DELETE', 0),
	(110, 'portfolio', 'READ_CLIENT', 'CLIENT', 'READ', 0),
	(111, 'portfolio', 'CREATE_CLIENT', 'CLIENT', 'CREATE', 0),
	(112, 'portfolio', 'CREATE_CLIENT_CHECKER', 'CLIENT', 'CREATE', 0),
	(113, 'portfolio', 'UPDATE_CLIENT', 'CLIENT', 'UPDATE', 0),
	(114, 'portfolio', 'UPDATE_CLIENT_CHECKER', 'CLIENT', 'UPDATE', 0),
	(115, 'portfolio', 'DELETE_CLIENT', 'CLIENT', 'DELETE', 0),
	(116, 'portfolio', 'DELETE_CLIENT_CHECKER', 'CLIENT', 'DELETE', 0),
	(117, 'portfolio', 'READ_CLIENTIMAGE', 'CLIENTIMAGE', 'READ', 0),
	(118, 'portfolio', 'CREATE_CLIENTIMAGE', 'CLIENTIMAGE', 'CREATE', 0),
	(119, 'portfolio', 'CREATE_CLIENTIMAGE_CHECKER', 'CLIENTIMAGE', 'CREATE', 0),
	(120, 'portfolio', 'DELETE_CLIENTIMAGE', 'CLIENTIMAGE', 'DELETE', 0),
	(121, 'portfolio', 'DELETE_CLIENTIMAGE_CHECKER', 'CLIENTIMAGE', 'DELETE', 0),
	(122, 'portfolio', 'READ_CLIENTNOTE', 'CLIENTNOTE', 'READ', 0),
	(123, 'portfolio', 'CREATE_CLIENTNOTE', 'CLIENTNOTE', 'CREATE', 0),
	(124, 'portfolio', 'CREATE_CLIENTNOTE_CHECKER', 'CLIENTNOTE', 'CREATE', 0),
	(125, 'portfolio', 'UPDATE_CLIENTNOTE', 'CLIENTNOTE', 'UPDATE', 0),
	(126, 'portfolio', 'UPDATE_CLIENTNOTE_CHECKER', 'CLIENTNOTE', 'UPDATE', 0),
	(127, 'portfolio', 'DELETE_CLIENTNOTE', 'CLIENTNOTE', 'DELETE', 0),
	(128, 'portfolio', 'DELETE_CLIENTNOTE_CHECKER', 'CLIENTNOTE', 'DELETE', 0),
	(129, 'portfolio_group', 'READ_GROUPNOTE', 'GROUPNOTE', 'READ', 0),
	(130, 'portfolio_group', 'CREATE_GROUPNOTE', 'GROUPNOTE', 'CREATE', 0),
	(131, 'portfolio_group', 'UPDATE_GROUPNOTE', 'GROUPNOTE', 'UPDATE', 0),
	(132, 'portfolio_group', 'DELETE_GROUPNOTE', 'GROUPNOTE', 'DELETE', 0),
	(133, 'portfolio_group', 'CREATE_GROUPNOTE_CHECKER', 'GROUPNOTE', 'CREATE', 0),
	(134, 'portfolio_group', 'UPDATE_GROUPNOTE_CHECKER', 'GROUPNOTE', 'UPDATE', 0),
	(135, 'portfolio_group', 'DELETE_GROUPNOTE_CHECKER', 'GROUPNOTE', 'DELETE', 0),
	(136, 'portfolio', 'READ_LOANNOTE', 'LOANNOTE', 'READ', 0),
	(137, 'portfolio', 'CREATE_LOANNOTE', 'LOANNOTE', 'CREATE', 0),
	(138, 'portfolio', 'UPDATE_LOANNOTE', 'LOANNOTE', 'UPDATE', 0),
	(139, 'portfolio', 'DELETE_LOANNOTE', 'LOANNOTE', 'DELETE', 0),
	(140, 'portfolio', 'CREATE_LOANNOTE_CHECKER', 'LOANNOTE', 'CREATE', 0),
	(141, 'portfolio', 'UPDATE_LOANNOTE_CHECKER', 'LOANNOTE', 'UPDATE', 0),
	(142, 'portfolio', 'DELETE_LOANNOTE_CHECKER', 'LOANNOTE', 'DELETE', 0),
	(143, 'portfolio', 'READ_LOANTRANSACTIONNOTE', 'LOANTRANSACTIONNOTE', 'READ', 0),
	(144, 'portfolio', 'CREATE_LOANTRANSACTIONNOTE', 'LOANTRANSACTIONNOTE', 'CREATE', 0),
	(145, 'portfolio', 'UPDATE_LOANTRANSACTIONNOTE', 'LOANTRANSACTIONNOTE', 'UPDATE', 0),
	(146, 'portfolio', 'DELETE_LOANTRANSACTIONNOTE', 'LOANTRANSACTIONNOTE', 'DELETE', 0),
	(147, 'portfolio', 'CREATE_LOANTRANSACTIONNOTE_CHECKER', 'LOANTRANSACTIONNOTE', 'CREATE', 0),
	(148, 'portfolio', 'UPDATE_LOANTRANSACTIONNOTE_CHECKER', 'LOANTRANSACTIONNOTE', 'UPDATE', 0),
	(149, 'portfolio', 'DELETE_LOANTRANSACTIONNOTE_CHECKER', 'LOANTRANSACTIONNOTE', 'DELETE', 0),
	(150, 'portfolio', 'READ_SAVINGNOTE', 'SAVINGNOTE', 'READ', 0),
	(151, 'portfolio', 'CREATE_SAVINGNOTE', 'SAVINGNOTE', 'CREATE', 0),
	(152, 'portfolio', 'UPDATE_SAVINGNOTE', 'SAVINGNOTE', 'UPDATE', 0),
	(153, 'portfolio', 'DELETE_SAVINGNOTE', 'SAVINGNOTE', 'DELETE', 0),
	(154, 'portfolio', 'CREATE_SAVINGNOTE_CHECKER', 'SAVINGNOTE', 'CREATE', 0),
	(155, 'portfolio', 'UPDATE_SAVINGNOTE_CHECKER', 'SAVINGNOTE', 'UPDATE', 0),
	(156, 'portfolio', 'DELETE_SAVINGNOTE_CHECKER', 'SAVINGNOTE', 'DELETE', 0),
	(157, 'portfolio', 'READ_CLIENTIDENTIFIER', 'CLIENTIDENTIFIER', 'READ', 0),
	(158, 'portfolio', 'CREATE_CLIENTIDENTIFIER', 'CLIENTIDENTIFIER', 'CREATE', 0),
	(159, 'portfolio', 'CREATE_CLIENTIDENTIFIER_CHECKER', 'CLIENTIDENTIFIER', 'CREATE', 0),
	(160, 'portfolio', 'UPDATE_CLIENTIDENTIFIER', 'CLIENTIDENTIFIER', 'UPDATE', 0),
	(161, 'portfolio', 'UPDATE_CLIENTIDENTIFIER_CHECKER', 'CLIENTIDENTIFIER', 'UPDATE', 0),
	(162, 'portfolio', 'DELETE_CLIENTIDENTIFIER', 'CLIENTIDENTIFIER', 'DELETE', 0),
	(163, 'portfolio', 'DELETE_CLIENTIDENTIFIER_CHECKER', 'CLIENTIDENTIFIER', 'DELETE', 0),
	(164, 'portfolio', 'READ_DOCUMENT', 'DOCUMENT', 'READ', 0),
	(165, 'portfolio', 'CREATE_DOCUMENT', 'DOCUMENT', 'CREATE', 0),
	(166, 'portfolio', 'CREATE_DOCUMENT_CHECKER', 'DOCUMENT', 'CREATE', 0),
	(167, 'portfolio', 'UPDATE_DOCUMENT', 'DOCUMENT', 'UPDATE', 0),
	(168, 'portfolio', 'UPDATE_DOCUMENT_CHECKER', 'DOCUMENT', 'UPDATE', 0),
	(169, 'portfolio', 'DELETE_DOCUMENT', 'DOCUMENT', 'DELETE', 0),
	(170, 'portfolio', 'DELETE_DOCUMENT_CHECKER', 'DOCUMENT', 'DELETE', 0),
	(171, 'portfolio_group', 'READ_GROUP', 'GROUP', 'READ', 0),
	(172, 'portfolio_group', 'CREATE_GROUP', 'GROUP', 'CREATE', 0),
	(173, 'portfolio_group', 'CREATE_GROUP_CHECKER', 'GROUP', 'CREATE', 0),
	(174, 'portfolio_group', 'UPDATE_GROUP', 'GROUP', 'UPDATE', 0),
	(175, 'portfolio_group', 'UPDATE_GROUP_CHECKER', 'GROUP', 'UPDATE', 0),
	(176, 'portfolio_group', 'DELETE_GROUP', 'GROUP', 'DELETE', 0),
	(177, 'portfolio_group', 'DELETE_GROUP_CHECKER', 'GROUP', 'DELETE', 0),
	(178, 'portfolio_group', 'UNASSIGNSTAFF_GROUP', 'GROUP', 'UNASSIGNSTAFF', 0),
	(179, 'portfolio_group', 'UNASSIGNSTAFF_GROUP_CHECKER', 'GROUP', 'UNASSIGNSTAFF', 0),
	(180, 'portfolio', 'CREATE_LOANCHARGE', 'LOANCHARGE', 'CREATE', 0),
	(181, 'portfolio', 'CREATE_LOANCHARGE_CHECKER', 'LOANCHARGE', 'CREATE', 0),
	(182, 'portfolio', 'UPDATE_LOANCHARGE', 'LOANCHARGE', 'UPDATE', 0),
	(183, 'portfolio', 'UPDATE_LOANCHARGE_CHECKER', 'LOANCHARGE', 'UPDATE', 0),
	(184, 'portfolio', 'DELETE_LOANCHARGE', 'LOANCHARGE', 'DELETE', 0),
	(185, 'portfolio', 'DELETE_LOANCHARGE_CHECKER', 'LOANCHARGE', 'DELETE', 0),
	(186, 'portfolio', 'WAIVE_LOANCHARGE', 'LOANCHARGE', 'WAIVE', 0),
	(187, 'portfolio', 'WAIVE_LOANCHARGE_CHECKER', 'LOANCHARGE', 'WAIVE', 0),
	(188, 'portfolio', 'READ_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'READ', 0),
	(189, 'portfolio', 'CREATE_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'CREATE', 0),
	(190, 'portfolio', 'CREATE_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'CREATE', 0),
	(191, 'portfolio', 'UPDATE_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'UPDATE', 0),
	(192, 'portfolio', 'UPDATE_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'UPDATE', 0),
	(193, 'portfolio', 'DELETE_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'DELETE', 0),
	(194, 'portfolio', 'DELETE_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'DELETE', 0),
	(195, 'portfolio', 'READ_GUARANTOR', 'GUARANTOR', 'READ', 0),
	(196, 'portfolio', 'CREATE_GUARANTOR', 'GUARANTOR', 'CREATE', 0),
	(197, 'portfolio', 'CREATE_GUARANTOR_CHECKER', 'GUARANTOR', 'CREATE', 0),
	(198, 'portfolio', 'UPDATE_GUARANTOR', 'GUARANTOR', 'UPDATE', 0),
	(199, 'portfolio', 'UPDATE_GUARANTOR_CHECKER', 'GUARANTOR', 'UPDATE', 0),
	(200, 'portfolio', 'DELETE_GUARANTOR', 'GUARANTOR', 'DELETE', 0),
	(201, 'portfolio', 'DELETE_GUARANTOR_CHECKER', 'GUARANTOR', 'DELETE', 0),
	(202, 'portfolio', 'READ_COLLATERAL', 'COLLATERAL', 'READ', 0),
	(203, 'portfolio', 'CREATE_COLLATERAL', 'COLLATERAL', 'CREATE', 0),
	(204, 'portfolio', 'UPDATE_COLLATERAL', 'COLLATERAL', 'UPDATE', 0),
	(205, 'portfolio', 'DELETE_COLLATERAL', 'COLLATERAL', 'DELETE', 0),
	(206, 'portfolio', 'CREATE_COLLATERAL_CHECKER', 'COLLATERAL', 'CREATE', 0),
	(207, 'portfolio', 'UPDATE_COLLATERAL_CHECKER', 'COLLATERAL', 'UPDATE', 0),
	(208, 'portfolio', 'DELETE_COLLATERAL_CHECKER', 'COLLATERAL', 'DELETE', 0),
	(209, 'transaction_loan', 'APPROVE_LOAN', 'LOAN', 'APPROVE', 0),
	(211, 'transaction_loan', 'REJECT_LOAN', 'LOAN', 'REJECT', 0),
	(213, 'transaction_loan', 'WITHDRAW_LOAN', 'LOAN', 'WITHDRAW', 0),
	(215, 'transaction_loan', 'APPROVALUNDO_LOAN', 'LOAN', 'APPROVALUNDO', 0),
	(216, 'transaction_loan', 'DISBURSE_LOAN', 'LOAN', 'DISBURSE', 0),
	(218, 'transaction_loan', 'DISBURSALUNDO_LOAN', 'LOAN', 'DISBURSALUNDO', 0),
	(219, 'transaction_loan', 'REPAYMENT_LOAN', 'LOAN', 'REPAYMENT', 0),
	(221, 'transaction_loan', 'ADJUST_LOAN', 'LOAN', 'ADJUST', 0),
	(222, 'transaction_loan', 'WAIVEINTERESTPORTION_LOAN', 'LOAN', 'WAIVEINTERESTPORTION', 0),
	(223, 'transaction_loan', 'WRITEOFF_LOAN', 'LOAN', 'WRITEOFF', 0),
	(224, 'transaction_loan', 'CLOSE_LOAN', 'LOAN', 'CLOSE', 0),
	(225, 'transaction_loan', 'CLOSEASRESCHEDULED_LOAN', 'LOAN', 'CLOSEASRESCHEDULED', 0),
	(226, 'transaction_loan', 'UPDATELOANOFFICER_LOAN', 'LOAN', 'UPDATELOANOFFICER', 0),
	(227, 'transaction_loan', 'UPDATELOANOFFICER_LOAN_CHECKER', 'LOAN', 'UPDATELOANOFFICER', 0),
	(228, 'transaction_loan', 'REMOVELOANOFFICER_LOAN', 'LOAN', 'REMOVELOANOFFICER', 0),
	(229, 'transaction_loan', 'REMOVELOANOFFICER_LOAN_CHECKER', 'LOAN', 'REMOVELOANOFFICER', 0),
	(230, 'transaction_loan', 'BULKREASSIGN_LOAN', 'LOAN', 'BULKREASSIGN', 0),
	(231, 'transaction_loan', 'BULKREASSIGN_LOAN_CHECKER', 'LOAN', 'BULKREASSIGN', 0),
	(232, 'transaction_loan', 'APPROVE_LOAN_CHECKER', 'LOAN', 'APPROVE', 0),
	(234, 'transaction_loan', 'REJECT_LOAN_CHECKER', 'LOAN', 'REJECT', 0),
	(236, 'transaction_loan', 'WITHDRAW_LOAN_CHECKER', 'LOAN', 'WITHDRAW', 0),
	(238, 'transaction_loan', 'APPROVALUNDO_LOAN_CHECKER', 'LOAN', 'APPROVALUNDO', 0),
	(239, 'transaction_loan', 'DISBURSE_LOAN_CHECKER', 'LOAN', 'DISBURSE', 0),
	(241, 'transaction_loan', 'DISBURSALUNDO_LOAN_CHECKER', 'LOAN', 'DISBURSALUNDO', 0),
	(242, 'transaction_loan', 'REPAYMENT_LOAN_CHECKER', 'LOAN', 'REPAYMENT', 0),
	(244, 'transaction_loan', 'ADJUST_LOAN_CHECKER', 'LOAN', 'ADJUST', 0),
	(245, 'transaction_loan', 'WAIVEINTERESTPORTION_LOAN_CHECKER', 'LOAN', 'WAIVEINTERESTPORTION', 0),
	(246, 'transaction_loan', 'WRITEOFF_LOAN_CHECKER', 'LOAN', 'WRITEOFF', 0),
	(247, 'transaction_loan', 'CLOSE_LOAN_CHECKER', 'LOAN', 'CLOSE', 0),
	(248, 'transaction_loan', 'CLOSEASRESCHEDULED_LOAN_CHECKER', 'LOAN', 'CLOSEASRESCHEDULED', 0),
	(249, 'transaction_savings', 'DEPOSIT_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'DEPOSIT', 0),
	(250, 'transaction_savings', 'DEPOSIT_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'DEPOSIT', 0),
	(251, 'transaction_savings', 'WITHDRAWAL_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'WITHDRAWAL', 0),
	(252, 'transaction_savings', 'WITHDRAWAL_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'WITHDRAWAL', 0),
	(253, 'transaction_savings', 'ACTIVATE_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'ACTIVATE', 0),
	(254, 'transaction_savings', 'ACTIVATE_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'ACTIVATE', 0),
	(255, 'transaction_savings', 'CALCULATEINTEREST_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'CALCULATEINTEREST', 0),
	(256, 'transaction_savings', 'CALCULATEINTEREST_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'CALCULATEINTEREST', 0),
	(257, 'accounting', 'CREATE_GLACCOUNT', 'GLACCOUNT', 'CREATE', 0),
	(258, 'accounting', 'UPDATE_GLACCOUNT', 'GLACCOUNT', 'UPDATE', 0),
	(259, 'accounting', 'DELETE_GLACCOUNT', 'GLACCOUNT', 'DELETE', 0),
	(260, 'accounting', 'CREATE_GLCLOSURE', 'GLCLOSURE', 'CREATE', 0),
	(261, 'accounting', 'UPDATE_GLCLOSURE', 'GLCLOSURE', 'UPDATE', 0),
	(262, 'accounting', 'DELETE_GLCLOSURE', 'GLCLOSURE', 'DELETE', 0),
	(263, 'accounting', 'CREATE_JOURNALENTRY', 'JOURNALENTRY', 'CREATE', 0),
	(264, 'accounting', 'REVERSE_JOURNALENTRY', 'JOURNALENTRY', 'REVERSE', 0),
	(265, 'report', 'READ_Active Loans - Details', 'Active Loans - Details', 'READ', 0),
	(266, 'report', 'READ_Active Loans - Summary', 'Active Loans - Summary', 'READ', 0),
	(267, 'report', 'READ_Active Loans by Disbursal Period', 'Active Loans by Disbursal Period', 'READ', 0),
	(268, 'report', 'READ_Active Loans in last installment', 'Active Loans in last installment', 'READ', 0),
	(269, 'report', 'READ_Active Loans in last installment Summary', 'Active Loans in last installment Summary', 'READ', 0),
	(270, 'report', 'READ_Active Loans Passed Final Maturity', 'Active Loans Passed Final Maturity', 'READ', 0),
	(271, 'report', 'READ_Active Loans Passed Final Maturity Summary', 'Active Loans Passed Final Maturity Summary', 'READ', 0),
	(272, 'report', 'READ_Aging Detail', 'Aging Detail', 'READ', 0),
	(273, 'report', 'READ_Aging Summary (Arrears in Months)', 'Aging Summary (Arrears in Months)', 'READ', 0),
	(274, 'report', 'READ_Aging Summary (Arrears in Weeks)', 'Aging Summary (Arrears in Weeks)', 'READ', 0),
	(275, 'report', 'READ_Balance Sheet', 'Balance Sheet', 'READ', 0),
	(276, 'report', 'READ_Branch Expected Cash Flow', 'Branch Expected Cash Flow', 'READ', 0),
	(277, 'report', 'READ_Client Listing', 'Client Listing', 'READ', 0),
	(278, 'report', 'READ_Client Loans Listing', 'Client Loans Listing', 'READ', 0),
	(279, 'report', 'READ_Expected Payments By Date - Basic', 'Expected Payments By Date - Basic', 'READ', 0),
	(280, 'report', 'READ_Expected Payments By Date - Formatted', 'Expected Payments By Date - Formatted', 'READ', 0),
	(281, 'report', 'READ_Funds Disbursed Between Dates Summary', 'Funds Disbursed Between Dates Summary', 'READ', 0),
	(282, 'report', 'READ_Funds Disbursed Between Dates Summary by Office', 'Funds Disbursed Between Dates Summary by Office', 'READ', 0),
	(283, 'report', 'READ_Income Statement', 'Income Statement', 'READ', 0),
	(284, 'report', 'READ_Loan Account Schedule', 'Loan Account Schedule', 'READ', 0),
	(285, 'report', 'READ_Loans Awaiting Disbursal', 'Loans Awaiting Disbursal', 'READ', 0),
	(286, 'report', 'READ_Loans Awaiting Disbursal Summary', 'Loans Awaiting Disbursal Summary', 'READ', 0),
	(287, 'report', 'READ_Loans Awaiting Disbursal Summary by Month', 'Loans Awaiting Disbursal Summary by Month', 'READ', 0),
	(288, 'report', 'READ_Loans Pending Approval', 'Loans Pending Approval', 'READ', 0),
	(289, 'report', 'READ_Obligation Met Loans Details', 'Obligation Met Loans Details', 'READ', 0),
	(290, 'report', 'READ_Obligation Met Loans Summary', 'Obligation Met Loans Summary', 'READ', 0),
	(291, 'report', 'READ_Portfolio at Risk', 'Portfolio at Risk', 'READ', 0),
	(292, 'report', 'READ_Portfolio at Risk by Branch', 'Portfolio at Risk by Branch', 'READ', 0),
	(293, 'report', 'READ_Rescheduled Loans', 'Rescheduled Loans', 'READ', 0),
	(294, 'report', 'READ_Trial Balance', 'Trial Balance', 'READ', 0),
	(295, 'report', 'READ_Written-Off Loans', 'Written-Off Loans', 'READ', 0),
	(296, 'transaction_savings', 'POSTINTEREST_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'POSTINTEREST', 1),
	(297, 'transaction_savings', 'POSTINTEREST_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'POSTINTEREST', 0),
	(298, 'portfolio_center', 'READ_CENTER', 'CENTER', 'READ', 0),
	(299, 'portfolio_center', 'CREATE_CENTER', 'CENTER', 'CREATE', 0),
	(300, 'portfolio_center', 'CREATE_CENTER_CHECKER', 'CENTER', 'CREATE', 0),
	(301, 'portfolio_center', 'UPDATE_CENTER', 'CENTER', 'UPDATE', 0),
	(302, 'portfolio_center', 'UPDATE_CENTER_CHECKER', 'CENTER', 'UPDATE', 0),
	(303, 'portfolio_center', 'DELETE_CENTER', 'CENTER', 'DELETE', 0),
	(304, 'portfolio_center', 'DELETE_CENTER_CHECKER', 'CENTER', 'DELETE', 0),
	(305, 'configuration', 'READ_REPORT', 'REPORT', 'READ', 0),
	(306, 'configuration', 'CREATE_REPORT', 'REPORT', 'CREATE', 0),
	(307, 'configuration', 'CREATE_REPORT_CHECKER', 'REPORT', 'CREATE', 0),
	(308, 'configuration', 'UPDATE_REPORT', 'REPORT', 'UPDATE', 0),
	(309, 'configuration', 'UPDATE_REPORT_CHECKER', 'REPORT', 'UPDATE', 0),
	(310, 'configuration', 'DELETE_REPORT', 'REPORT', 'DELETE', 0),
	(311, 'configuration', 'DELETE_REPORT_CHECKER', 'REPORT', 'DELETE', 0),
	(312, 'portfolio', 'ACTIVATE_CLIENT', 'CLIENT', 'ACTIVATE', 1),
	(313, 'portfolio', 'ACTIVATE_CLIENT_CHECKER', 'CLIENT', 'ACTIVATE', 0),
	(314, 'portfolio_center', 'ACTIVATE_CENTER', 'CENTER', 'ACTIVATE', 1),
	(315, 'portfolio_center', 'ACTIVATE_CENTER_CHECKER', 'CENTER', 'ACTIVATE', 0),
	(316, 'portfolio_group', 'ACTIVATE_GROUP', 'GROUP', 'ACTIVATE', 1),
	(317, 'portfolio_group', 'ACTIVATE_GROUP_CHECKER', 'GROUP', 'ACTIVATE', 0),
	(318, 'portfolio_group', 'ASSOCIATECLIENTS_GROUP', 'GROUP', 'ASSOCIATECLIENTS', 0),
	(319, 'portfolio_group', 'DISASSOCIATECLIENTS_GROUP', 'GROUP', 'DISASSOCIATECLIENTS', 0),
	(320, 'portfolio_group', 'SAVECOLLECTIONSHEET_GROUP', 'GROUP', 'SAVECOLLECTIONSHEET', 0),
	(321, 'portfolio_center', 'SAVECOLLECTIONSHEET_CENTER', 'CENTER', 'SAVECOLLECTIONSHEET', 0),
	(323, 'accounting', 'DELETE_ACCOUNTINGRULE', 'ACCOUNTINGRULE', 'DELETE', 0),
	(324, 'accounting', 'CREATE_ACCOUNTINGRULE', 'ACCOUNTINGRULE', 'CREATE', 0),
	(325, 'accounting', 'UPDATE_ACCOUNTINGRULE', 'ACCOUNTINGRULE', 'UPDATE', 0),
	(326, 'report', 'READ_GroupSummaryCounts', 'GroupSummaryCounts', 'READ', 0),
	(327, 'report', 'READ_GroupSummaryAmounts', 'GroupSummaryAmounts', 'READ', 0),
	(328, 'configuration', 'CREATE_DATATABLE', 'DATATABLE', 'CREATE', 0),
	(329, 'configuration', 'CREATE_DATATABLE_CHECKER', 'DATATABLE', 'CREATE', 0),
	(330, 'configuration', 'UPDATE_DATATABLE', 'DATATABLE', 'UPDATE', 0),
	(331, 'configuration', 'UPDATE_DATATABLE_CHECKER', 'DATATABLE', 'UPDATE', 0),
	(332, 'configuration', 'DELETE_DATATABLE', 'DATATABLE', 'DELETE', 0),
	(333, 'configuration', 'DELETE_DATATABLE_CHECKER', 'DATATABLE', 'DELETE', 0),
	(334, 'organisation', 'CREATE_HOLIDAY', 'HOLIDAY', 'CREATE', 0),
	(335, 'portfolio_group', 'ASSIGNROLE_GROUP', 'GROUP', 'ASSIGNROLE', 0),
	(336, 'portfolio_group', 'UNASSIGNROLE_GROUP', 'GROUP', 'UNASSIGNROLE', 0),
	(337, 'portfolio_group', 'UPDATEROLE_GROUP', 'GROUP', 'UPDATEROLE', 0),
	(346, 'report', 'READ_TxnRunningBalances', 'TxnRunningBalances', 'READ', 0),
	(347, 'portfolio', 'UNASSIGNSTAFF_CLIENT', 'CLIENT', 'UNASSIGNSTAFF', 0),
	(348, 'portfolio', 'ASSIGNSTAFF_CLIENT', 'CLIENT', 'ASSIGNSTAFF', 0),
	(349, 'portfolio', 'CLOSE_CLIENT', 'CLIENT', 'CLOSE', 1),
	(350, 'report', 'READ_FieldAgentStats', 'FieldAgentStats', 'READ', 0),
	(351, 'report', 'READ_FieldAgentPrograms', 'FieldAgentPrograms', 'READ', 0),
	(352, 'report', 'READ_ProgramDetails', 'ProgramDetails', 'READ', 0),
	(353, 'report', 'READ_ChildrenStaffList', 'ChildrenStaffList', 'READ', 0),
	(354, 'report', 'READ_CoordinatorStats', 'CoordinatorStats', 'READ', 0),
	(355, 'report', 'READ_BranchManagerStats', 'BranchManagerStats', 'READ', 0),
	(356, 'report', 'READ_ProgramDirectorStats', 'ProgramDirectorStats', 'READ', 0),
	(357, 'report', 'READ_ProgramStats', 'ProgramStats', 'READ', 0),
	(358, 'transaction_savings', 'APPROVE_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'APPROVE', 1),
	(359, 'transaction_savings', 'REJECT_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'REJECT', 1),
	(360, 'transaction_savings', 'WITHDRAW_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'WITHDRAW', 1),
	(361, 'transaction_savings', 'APPROVALUNDO_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'APPROVALUNDO', 1),
	(362, 'transaction_savings', 'CLOSE_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'CLOSE', 1),
	(363, 'transaction_savings', 'APPROVE_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'APPROVE', 0),
	(364, 'transaction_savings', 'REJECT_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'REJECT', 0),
	(365, 'transaction_savings', 'WITHDRAW_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'WITHDRAW', 0),
	(366, 'transaction_savings', 'APPROVALUNDO_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'APPROVALUNDO', 0),
	(367, 'transaction_savings', 'CLOSE_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'CLOSE', 0),
	(368, 'transaction_savings', 'UNDOTRANSACTION_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'UNDOTRANSACTION', 1),
	(369, 'transaction_savings', 'UNDOTRANSACTION_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'UNDOTRANSACTION', 0),
	(370, 'portfolio', 'CREATE_PRODUCTMIX', 'PRODUCTMIX', 'CREATE', 0),
	(371, 'portfolio', 'UPDATE_PRODUCTMIX', 'PRODUCTMIX', 'UPDATE', 0),
	(372, 'portfolio', 'DELETE_PRODUCTMIX', 'PRODUCTMIX', 'DELETE', 0),
	(373, 'jobs', 'UPDATE_SCHEDULER', 'SCHEDULER', 'UPDATE', 0),
	(374, 'transaction_savings', 'APPLYANNUALFEE_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'APPLYANNUALFEE', 1),
	(375, 'transaction_savings', 'APPLYANNUALFEE_SAVINGSACCOUNT_CHECKER', 'SAVINGSACCOUNT', 'APPLYANNUALFEE', 0),
	(376, 'portfolio_group', 'ASSIGNSTAFF_GROUP', 'GROUP', 'ASSIGNSTAFF', 0),
	(377, 'transaction_savings', 'READ_ACCOUNTTRANSFER', 'ACCOUNTTRANSFER', 'READ', 0),
	(378, 'transaction_savings', 'CREATE_ACCOUNTTRANSFER', 'ACCOUNTTRANSFER', 'CREATE', 1),
	(379, 'transaction_savings', 'CREATE_ACCOUNTTRANSFER_CHECKER', 'ACCOUNTTRANSFER', 'CREATE', 0),
	(380, 'transaction_savings', 'ADJUSTTRANSACTION_SAVINGSACCOUNT', 'SAVINGSACCOUNT', 'ADJUSTTRANSACTION', 0),
	(381, 'portfolio', 'CREATE_MEETING', 'MEETING', 'CREATE', 0),
	(382, 'portfolio', 'UPDATE_MEETING', 'MEETING', 'UPDATE', 0),
	(383, 'portfolio', 'DELETE_MEETING', 'MEETING', 'DELETE', 0),
	(384, 'portfolio', 'SAVEORUPDATEATTENDANCE_MEETING', 'MEETING', 'SAVEORUPDATEATTENDANCE', 0),
	(385, 'portfolio_group', 'TRANSFERCLIENTS_GROUP', 'GROUP', 'TRANSFERCLIENTS', 0),
	(386, 'portfolio_group', 'TRANSFERCLIENTS_GROUP_CHECKER', 'GROUP', 'TRANSFERCLIENTS', 0),
	(389, 'portfolio', 'PROPOSETRANSFER_CLIENT', 'CLIENT', 'PROPOSETRANSFER', 0),
	(390, 'portfolio', 'PROPOSETRANSFER_CLIENT_CHECKER', 'CLIENT', 'PROPOSETRANSFER', 0),
	(391, 'portfolio', 'ACCEPTTRANSFER_CLIENT', 'CLIENT', 'ACCEPTTRANSFER', 0),
	(392, 'portfolio', 'ACCEPTTRANSFER_CLIENT_CHECKER', 'CLIENT', 'ACCEPTTRANSFER', 0),
	(393, 'portfolio', 'REJECTTRANSFER_CLIENT', 'CLIENT', 'REJECTTRANSFER', 0),
	(394, 'portfolio', 'REJECTTRANSFER_CLIENT_CHECKER', 'CLIENT', 'REJECTTRANSFER', 0),
	(395, 'portfolio', 'WITHDRAWTRANSFER_CLIENT', 'CLIENT', 'WITHDRAWTRANSFER', 0),
	(396, 'portfolio', 'WITHDRAWTRANSFER_CLIENT_CHECKER', 'CLIENT', 'WITHDRAWTRANSFER', 0),
	(397, 'portfolio', 'CLOSE_GROUP', 'GROUP', 'CLOSE', 1),
	(398, 'portfolio', 'CLOSE_CENTER', 'CENTER', 'CLOSE', 1),
	(399, 'xbrlmapping', 'UPDATE_XBRLMAPPING', 'XBRLMAPPING', 'UPDATE', 0),
	(400, 'configuration', 'READ_CACHE', 'CACHE', 'READ', 0),
	(401, 'configuration', 'UPDATE_CACHE', 'CACHE', 'UPDATE', 0),
	(402, 'transaction_loan', 'PAY_LOANCHARGE', 'LOANCHARGE', 'PAY', 0),
	(403, 'portfolio', 'CREATE_SAVINGSACCOUNTCHARGE', 'SAVINGSACCOUNTCHARGE', 'CREATE', 0),
	(404, 'portfolio', 'CREATE_SAVINGSACCOUNTCHARGE_CHECKER', 'SAVINGSACCOUNTCHARGE', 'CREATE', 0),
	(405, 'portfolio', 'UPDATE_SAVINGSACCOUNTCHARGE', 'SAVINGSACCOUNTCHARGE', 'UPDATE', 0),
	(406, 'portfolio', 'UPDATE_SAVINGSACCOUNTCHARGE_CHECKER', 'SAVINGSACCOUNTCHARGE', 'UPDATE', 0),
	(407, 'portfolio', 'DELETE_SAVINGSACCOUNTCHARGE', 'SAVINGSACCOUNTCHARGE', 'DELETE', 0),
	(408, 'portfolio', 'DELETE_SAVINGSACCOUNTCHARGE_CHECKER', 'SAVINGSACCOUNTCHARGE', 'DELETE', 0),
	(409, 'portfolio', 'WAIVE_SAVINGSACCOUNTCHARGE', 'SAVINGSACCOUNTCHARGE', 'WAIVE', 0),
	(410, 'portfolio', 'WAIVE_SAVINGSACCOUNTCHARGE_CHECKER', 'SAVINGSACCOUNTCHARGE', 'WAIVE', 0),
	(411, 'portfolio', 'PAY_SAVINGSACCOUNTCHARGE', 'SAVINGSACCOUNTCHARGE', 'PAY', 0),
	(412, 'portfolio', 'PAY_SAVINGSACCOUNTCHARGE_CHECKER', 'SAVINGSACCOUNTCHARGE', 'PAY', 0),
	(413, 'portfolio', 'PROPOSEANDACCEPTTRANSFER_CLIENT', 'CLIENT', 'PROPOSEANDACCEPTTRANSFER', 0),
	(414, 'portfolio', 'PROPOSEANDACCEPTTRANSFER_CLIENT_CHECKER', 'CLIENT', 'PROPOSEANDACCEPTTRANSFER', 0),
	(415, 'organisation', 'DELETE_TEMPLATE', 'TEMPLATE', 'DELETE', 0),
	(416, 'organisation', 'CREATE_TEMPLATE', 'TEMPLATE', 'CREATE', 0),
	(417, 'organisation', 'UPDATE_TEMPLATE', 'TEMPLATE', 'UPDATE', 0),
	(418, 'organisation', 'READ_TEMPLATE', 'TEMPLATE', 'READ', 0),
	(419, 'accounting', 'UPDATERUNNINGBALANCE_JOURNALENTRY', 'JOURNALENTRY', 'UPDATERUNNINGBALANCE', 0),
	(420, 'organisation', 'READ_SMS', 'SMS', 'READ', 0),
	(421, 'organisation', 'CREATE_SMS', 'SMS', 'CREATE', 0),
	(422, 'organisation', 'CREATE_SMS_CHECKER', 'SMS', 'CREATE', 0),
	(423, 'organisation', 'UPDATE_SMS', 'SMS', 'UPDATE', 0),
	(424, 'organisation', 'UPDATE_SMS_CHECKER', 'SMS', 'UPDATE', 0),
	(425, 'organisation', 'DELETE_SMS', 'SMS', 'DELETE', 0),
	(426, 'organisation', 'DELETE_SMS_CHECKER', 'SMS', 'DELETE', 0),
	(427, 'organisation', 'CREATE_HOLIDAY_CHECKER', 'HOLIDAY', 'CREATE', 0),
	(428, 'organisation', 'ACTIVATE_HOLIDAY', 'HOLIDAY', 'ACTIVATE', 0),
	(429, 'organisation', 'ACTIVATE_HOLIDAY_CHECKER', 'HOLIDAY', 'ACTIVATE', 0),
	(430, 'organisation', 'UPDATE_HOLIDAY', 'HOLIDAY', 'UPDATE', 0),
	(431, 'organisation', 'UPDATE_HOLIDAY_CHECKER', 'HOLIDAY', 'UPDATE', 0),
	(432, 'organisation', 'DELETE_HOLIDAY', 'HOLIDAY', 'DELETE', 0),
	(433, 'organisation', 'DELETE_HOLIDAY_CHECKER', 'HOLIDAY', 'DELETE', 0),
	(434, 'transaction_loan', 'UNDOWRITEOFF_LOAN', 'LOAN', 'UNDOWRITEOFF', 0),
	(435, 'portfolio', 'READ_SAVINGSACCOUNTCHARGE', 'SAVINGSACCOUNTCHARGE', 'READ', 0),
	(436, 'accounting', 'CREATE_JOURNALENTRY_CHECKER', 'JOURNALENTRY', 'CREATE', 0),
	(437, 'portfolio', 'UPDATE_DISBURSEMENTDETAIL', 'DISBURSEMENTDETAIL', 'UPDATE', 0),
	(438, 'portfolio', 'UPDATESAVINGSACCOUNT_CLIENT', 'CLIENT', 'UPDATESAVINGSACCOUNT', 0),
	(439, 'accounting', 'READ_ACCOUNTINGRULE', 'ACCOUNTINGRULE', 'READ', 0),
	(440, 'accounting', 'READ_JOURNALENTRY', 'JOURNALENTRY', 'READ', 0),
	(441, 'accounting', 'READ_GLACCOUNT', 'GLACCOUNT', 'READ', 0),
	(442, 'accounting', 'READ_GLCLOSURE', 'GLCLOSURE', 'READ', 0),
	(443, 'organisation', 'READ_HOLIDAY', 'HOLIDAY', 'READ', 0),
	(444, 'jobs', 'READ_SCHEDULER', 'SCHEDULER', 'READ', 0),
	(445, 'portfolio', 'READ_PRODUCTMIX', 'PRODUCTMIX', 'READ', 0),
	(446, 'portfolio', 'READ_MEETING', 'MEETING', 'READ', 0),
	(447, 'jobs', 'EXECUTEJOB_SCHEDULER', 'SCHEDULER', 'EXECUTEJOB', 0),
	(448, 'account_transfer', 'READ_STANDINGINSTRUCTION ', 'STANDINGINSTRUCTION ', 'READ', 0),
	(449, 'account_transfer', 'CREATE_STANDINGINSTRUCTION ', 'STANDINGINSTRUCTION ', 'CREATE', 0),
	(450, 'account_transfer', 'UPDATE_STANDINGINSTRUCTION ', 'STANDINGINSTRUCTION ', 'UPDATE', 0),
	(451, 'account_transfer', 'DELETE_STANDINGINSTRUCTION ', 'STANDINGINSTRUCTION ', 'DELETE', 0),
	(452, 'portfolio', 'CREATE_INTERESTRATECHART', 'INTERESTRATECHART', 'CREATE', 0),
	(453, 'portfolio', 'CREATE_INTERESTRATECHART_CHECKER', 'INTERESTRATECHART', 'CREATE', 0),
	(454, 'portfolio', 'UPDATE_INTERESTRATECHART', 'INTERESTRATECHART', 'UPDATE', 0),
	(455, 'portfolio', 'DELETE_INTERESTRATECHART', 'INTERESTRATECHART', 'DELETE', 0),
	(456, 'portfolio', 'UPDATE_INTERESTRATECHART_CHECKER', 'INTERESTRATECHART', 'UPDATE', 0),
	(457, 'portfolio', 'DELETE_INTERESTRATECHART_CHECKER', 'INTERESTRATECHART', 'DELETE', 0),
	(458, 'portfolio', 'CREATE_CHARTSLAB', 'CHARTSLAB', 'CREATE', 0),
	(459, 'portfolio', 'CREATE_CHARTSLAB_CHECKER', 'CHARTSLAB', 'CREATE', 0),
	(460, 'portfolio', 'UPDATE_CHARTSLAB', 'CHARTSLAB', 'UPDATE', 0),
	(461, 'portfolio', 'DELETE_CHARTSLAB', 'CHARTSLAB', 'DELETE', 0),
	(462, 'portfolio', 'UPDATE_CHARTSLAB_CHECKER', 'CHARTSLAB', 'UPDATE', 0),
	(463, 'portfolio', 'DELETE_CHARTSLAB_CHECKER', 'CHARTSLAB', 'DELETE', 0),
	(464, 'portfolio', 'CREATE_FIXEDDEPOSITPRODUCT', 'FIXEDDEPOSITPRODUCT', 'CREATE', 0),
	(465, 'portfolio', 'CREATE_FIXEDDEPOSITPRODUCT_CHECKER', 'FIXEDDEPOSITPRODUCT', 'CREATE', 0),
	(466, 'portfolio', 'UPDATE_FIXEDDEPOSITPRODUCT', 'FIXEDDEPOSITPRODUCT', 'UPDATE', 0),
	(467, 'portfolio', 'DELETE_FIXEDDEPOSITPRODUCT', 'FIXEDDEPOSITPRODUCT', 'DELETE', 0),
	(468, 'portfolio', 'UPDATE_FIXEDDEPOSITPRODUCT_CHECKER', 'FIXEDDEPOSITPRODUCT', 'UPDATE', 0),
	(469, 'portfolio', 'DELETE_FIXEDDEPOSITPRODUCT_CHECKER', 'FIXEDDEPOSITPRODUCT', 'DELETE', 0),
	(470, 'portfolio', 'CREATE_RECURRINGDEPOSITPRODUCT', 'RECURRINGDEPOSITPRODUCT', 'CREATE', 0),
	(471, 'portfolio', 'CREATE_RECURRINGDEPOSITPRODUCT_CHECKER', 'RECURRINGDEPOSITPRODUCT', 'CREATE', 0),
	(472, 'portfolio', 'UPDATE_RECURRINGDEPOSITPRODUCT', 'RECURRINGDEPOSITPRODUCT', 'UPDATE', 0),
	(473, 'portfolio', 'DELETE_RECURRINGDEPOSITPRODUCT', 'RECURRINGDEPOSITPRODUCT', 'DELETE', 0),
	(474, 'portfolio', 'UPDATE_RECURRINGDEPOSITPRODUCT_CHECKER', 'RECURRINGDEPOSITPRODUCT', 'UPDATE', 0),
	(475, 'portfolio', 'DELETE_RECURRINGDEPOSITPRODUCT_CHECKER', 'RECURRINGDEPOSITPRODUCT', 'DELETE', 0),
	(476, 'portfolio', 'READ_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'READ', 0),
	(477, 'portfolio', 'CREATE_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'CREATE', 0),
	(478, 'portfolio', 'CREATE_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'CREATE', 0),
	(479, 'portfolio', 'UPDATE_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'UPDATE', 0),
	(480, 'portfolio', 'UPDATE_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'UPDATE', 0),
	(481, 'portfolio', 'DELETE_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'DELETE', 0),
	(482, 'portfolio', 'DELETE_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'DELETE', 0),
	(483, 'transaction_savings', 'DEPOSIT_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'DEPOSIT', 0),
	(484, 'transaction_savings', 'DEPOSIT_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'DEPOSIT', 0),
	(485, 'transaction_savings', 'WITHDRAWAL_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'WITHDRAWAL', 0),
	(486, 'transaction_savings', 'WITHDRAWAL_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'WITHDRAWAL', 0),
	(487, 'transaction_savings', 'ACTIVATE_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'ACTIVATE', 0),
	(488, 'transaction_savings', 'ACTIVATE_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'ACTIVATE', 0),
	(489, 'transaction_savings', 'CALCULATEINTEREST_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'CALCULATEINTEREST', 0),
	(490, 'transaction_savings', 'CALCULATEINTEREST_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'CALCULATEINTEREST', 0),
	(491, 'transaction_savings', 'POSTINTEREST_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'POSTINTEREST', 1),
	(492, 'transaction_savings', 'POSTINTEREST_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'POSTINTEREST', 0),
	(493, 'transaction_savings', 'APPROVE_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'APPROVE', 1),
	(494, 'transaction_savings', 'REJECT_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'REJECT', 1),
	(495, 'transaction_savings', 'WITHDRAW_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'WITHDRAW', 1),
	(496, 'transaction_savings', 'APPROVALUNDO_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'APPROVALUNDO', 1),
	(497, 'transaction_savings', 'CLOSE_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'CLOSE', 1),
	(498, 'transaction_savings', 'APPROVE_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'APPROVE', 0),
	(499, 'transaction_savings', 'REJECT_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'REJECT', 0),
	(500, 'transaction_savings', 'WITHDRAW_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'WITHDRAW', 0),
	(501, 'transaction_savings', 'APPROVALUNDO_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'APPROVALUNDO', 0),
	(502, 'transaction_savings', 'CLOSE_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'CLOSE', 0),
	(503, 'transaction_savings', 'UNDOTRANSACTION_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'UNDOTRANSACTION', 1),
	(504, 'transaction_savings', 'UNDOTRANSACTION_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'UNDOTRANSACTION', 0),
	(505, 'transaction_savings', 'ADJUSTTRANSACTION_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'ADJUSTTRANSACTION', 0),
	(506, 'portfolio', 'READ_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'READ', 0),
	(507, 'portfolio', 'CREATE_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'CREATE', 0),
	(508, 'portfolio', 'CREATE_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'CREATE', 0),
	(509, 'portfolio', 'UPDATE_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'UPDATE', 0),
	(510, 'portfolio', 'UPDATE_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'UPDATE', 0),
	(511, 'portfolio', 'DELETE_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'DELETE', 0),
	(512, 'portfolio', 'DELETE_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'DELETE', 0),
	(513, 'transaction_savings', 'DEPOSIT_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'DEPOSIT', 0),
	(514, 'transaction_savings', 'DEPOSIT_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'DEPOSIT', 0),
	(515, 'transaction_savings', 'WITHDRAWAL_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'WITHDRAWAL', 0),
	(516, 'transaction_savings', 'WITHDRAWAL_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'WITHDRAWAL', 0),
	(517, 'transaction_savings', 'ACTIVATE_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'ACTIVATE', 0),
	(518, 'transaction_savings', 'ACTIVATE_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'ACTIVATE', 0),
	(519, 'transaction_savings', 'CALCULATEINTEREST_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'CALCULATEINTEREST', 0),
	(520, 'transaction_savings', 'CALCULATEINTEREST_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'CALCULATEINTEREST', 0),
	(521, 'transaction_savings', 'POSTINTEREST_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'POSTINTEREST', 1),
	(522, 'transaction_savings', 'POSTINTEREST_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'POSTINTEREST', 0),
	(523, 'transaction_savings', 'APPROVE_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'APPROVE', 1),
	(524, 'transaction_savings', 'REJECT_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'REJECT', 1),
	(525, 'transaction_savings', 'WITHDRAW_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'WITHDRAW', 1),
	(526, 'transaction_savings', 'APPROVALUNDO_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'APPROVALUNDO', 1),
	(527, 'transaction_savings', 'CLOSE_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'CLOSE', 1),
	(528, 'transaction_savings', 'APPROVE_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'APPROVE', 0),
	(529, 'transaction_savings', 'REJECT_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'REJECT', 0),
	(530, 'transaction_savings', 'WITHDRAW_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'WITHDRAW', 0),
	(531, 'transaction_savings', 'APPROVALUNDO_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'APPROVALUNDO', 0),
	(532, 'transaction_savings', 'CLOSE_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'CLOSE', 0),
	(533, 'transaction_savings', 'UNDOTRANSACTION_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'UNDOTRANSACTION', 1),
	(534, 'transaction_savings', 'UNDOTRANSACTION_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'UNDOTRANSACTION', 0),
	(535, 'transaction_savings', 'ADJUSTTRANSACTION_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'ADJUSTTRANSACTION', 0),
	(536, 'transaction_savings', 'PREMATURECLOSE_FIXEDDEPOSITACCOUNT_CHECKER', 'FIXEDDEPOSITACCOUNT', 'PREMATURECLOSE', 0),
	(537, 'transaction_savings', 'PREMATURECLOSE_FIXEDDEPOSITACCOUNT', 'FIXEDDEPOSITACCOUNT', 'PREMATURECLOSE', 1),
	(538, 'transaction_savings', 'PREMATURECLOSE_RECURRINGDEPOSITACCOUNT_CHECKER', 'RECURRINGDEPOSITACCOUNT', 'PREMATURECLOSE', 0),
	(539, 'transaction_savings', 'PREMATURECLOSE_RECURRINGDEPOSITACCOUNT', 'RECURRINGDEPOSITACCOUNT', 'PREMATURECLOSE', 1),
	(540, 'transaction_loan', 'DISBURSETOSAVINGS_LOAN', 'LOAN', 'DISBURSETOSAVINGS', 0);
/*!40000 ALTER TABLE `m_permission` ENABLE KEYS */;


-- m_portfolio_account_associations
CREATE TABLE IF NOT EXISTS `m_portfolio_account_associations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_account_id` bigint(20) DEFAULT NULL,
  `savings_account_id` bigint(20) DEFAULT NULL,
  `linked_loan_account_id` bigint(20) DEFAULT NULL,
  `linked_savings_account_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_association_loan_fk` (`loan_account_id`),
  KEY `account_association_savings_fk` (`savings_account_id`),
  KEY `linked_loan_fk` (`linked_loan_account_id`),
  KEY `linked_savings_fk` (`linked_savings_account_id`),
  CONSTRAINT `account_association_loan_fk` FOREIGN KEY (`loan_account_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `account_association_savings_fk` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`),
  CONSTRAINT `linked_loan_fk` FOREIGN KEY (`linked_loan_account_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `linked_savings_fk` FOREIGN KEY (`linked_savings_account_id`) REFERENCES `m_savings_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_portfolio_account_associations: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_portfolio_account_associations` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_portfolio_account_associations` ENABLE KEYS */;


-- m_portfolio_command_source
CREATE TABLE IF NOT EXISTS `m_portfolio_command_source` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `action_name` varchar(50) NOT NULL,
  `entity_name` varchar(50) NOT NULL,
  `office_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `loan_id` bigint(20) DEFAULT NULL,
  `savings_account_id` bigint(20) DEFAULT NULL,
  `api_get_url` varchar(100) NOT NULL,
  `resource_id` bigint(20) DEFAULT NULL,
  `subresource_id` bigint(20) DEFAULT NULL,
  `command_as_json` text NOT NULL,
  `maker_id` bigint(20) NOT NULL,
  `made_on_date` datetime NOT NULL,
  `checker_id` bigint(20) DEFAULT NULL,
  `checked_on_date` datetime DEFAULT NULL,
  `processing_result_enum` smallint(5) NOT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_maker_m_appuser` (`maker_id`),
  KEY `FK_m_checker_m_appuser` (`checker_id`),
  KEY `action_name` (`action_name`),
  KEY `entity_name` (`entity_name`,`resource_id`),
  KEY `made_on_date` (`made_on_date`),
  KEY `checked_on_date` (`checked_on_date`),
  KEY `processing_result_enum` (`processing_result_enum`),
  KEY `office_id` (`office_id`),
  KEY `group_id` (`office_id`),
  KEY `client_id` (`office_id`),
  KEY `loan_id` (`office_id`),
  CONSTRAINT `FK_m_checker_m_appuser` FOREIGN KEY (`checker_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_m_maker_m_appuser` FOREIGN KEY (`maker_id`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_portfolio_command_source: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_portfolio_command_source` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_portfolio_command_source` ENABLE KEYS */;


-- m_product_loan
CREATE TABLE IF NOT EXISTS `m_product_loan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `short_name` varchar(4) NOT NULL,
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `principal_amount` decimal(19,6) NOT NULL,
  `min_principal_amount` decimal(19,6) DEFAULT NULL,
  `max_principal_amount` decimal(19,6) DEFAULT NULL,
  `arrearstolerance_amount` decimal(19,6) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `fund_id` bigint(20) DEFAULT NULL,
  `nominal_interest_rate_per_period` decimal(19,6) NOT NULL,
  `min_nominal_interest_rate_per_period` decimal(19,6) DEFAULT NULL,
  `max_nominal_interest_rate_per_period` decimal(19,6) DEFAULT NULL,
  `interest_period_frequency_enum` smallint(5) NOT NULL,
  `annual_nominal_interest_rate` decimal(19,6) NOT NULL,
  `interest_method_enum` smallint(5) NOT NULL,
  `interest_calculated_in_period_enum` smallint(5) NOT NULL DEFAULT '1',
  `repay_every` smallint(5) NOT NULL,
  `repayment_period_frequency_enum` smallint(5) NOT NULL,
  `number_of_repayments` smallint(5) NOT NULL,
  `min_number_of_repayments` smallint(5) DEFAULT NULL,
  `max_number_of_repayments` smallint(5) DEFAULT NULL,
  `grace_on_principal_periods` smallint(5) DEFAULT NULL,
  `grace_on_interest_periods` smallint(5) DEFAULT NULL,
  `grace_interest_free_periods` smallint(5) DEFAULT NULL,
  `amortization_method_enum` smallint(5) NOT NULL,
  `accounting_type` smallint(5) NOT NULL,
  `loan_transaction_strategy_id` bigint(20) DEFAULT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `include_in_borrower_cycle` tinyint(1) NOT NULL DEFAULT '0',
  `use_borrower_cycle` tinyint(1) NOT NULL DEFAULT '0',
  `start_date` date DEFAULT NULL,
  `close_date` date DEFAULT NULL,
  `allow_multiple_disbursals` tinyint(1) NOT NULL DEFAULT '0',
  `max_disbursals` int(2) DEFAULT NULL,
  `max_outstanding_loan_balance` decimal(19,6) DEFAULT NULL,
  `grace_on_arrears_ageing` smallint(5) DEFAULT NULL,
  `overdue_days_for_npa` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_name` (`name`),
  UNIQUE KEY `unq_short_name` (`short_name`),
  UNIQUE KEY `external_id_UNIQUE` (`external_id`),
  KEY `FKA6A8A7D77240145` (`fund_id`),
  KEY `FK_ltp_strategy` (`loan_transaction_strategy_id`),
  CONSTRAINT `FKA6A8A7D77240145` FOREIGN KEY (`fund_id`) REFERENCES `m_fund` (`id`),
  CONSTRAINT `FK_ltp_strategy` FOREIGN KEY (`loan_transaction_strategy_id`) REFERENCES `ref_loan_transaction_processing_strategy` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_product_loan: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_product_loan` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_product_loan` ENABLE KEYS */;


-- m_product_loan_charge
CREATE TABLE IF NOT EXISTS `m_product_loan_charge` (
  `product_loan_id` bigint(20) NOT NULL,
  `charge_id` bigint(20) NOT NULL,
  PRIMARY KEY (`product_loan_id`,`charge_id`),
  KEY `charge_id` (`charge_id`),
  CONSTRAINT `m_product_loan_charge_ibfk_1` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `m_product_loan_charge_ibfk_2` FOREIGN KEY (`product_loan_id`) REFERENCES `m_product_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_product_loan_charge: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_product_loan_charge` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_product_loan_charge` ENABLE KEYS */;


-- m_product_loan_variations_borrower_cycle
CREATE TABLE IF NOT EXISTS `m_product_loan_variations_borrower_cycle` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_product_id` bigint(20) NOT NULL DEFAULT '0',
  `borrower_cycle_number` int(3) NOT NULL DEFAULT '0',
  `value_condition` int(1) NOT NULL DEFAULT '0',
  `param_type` int(1) NOT NULL DEFAULT '0',
  `default_value` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `max_value` decimal(19,6) DEFAULT NULL,
  `min_value` decimal(19,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `borrower_cycle_loan_product_FK` (`loan_product_id`),
  CONSTRAINT `borrower_cycle_loan_product_FK` FOREIGN KEY (`loan_product_id`) REFERENCES `m_product_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_product_loan_variations_borrower_cycle: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_product_loan_variations_borrower_cycle` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_product_loan_variations_borrower_cycle` ENABLE KEYS */;


-- m_product_mix
CREATE TABLE IF NOT EXISTS `m_product_mix` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `restricted_product_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_product_mix_product_id_to_m_product_loan` (`product_id`),
  KEY `FK_m_product_mix_restricted_product_id_to_m_product_loan` (`restricted_product_id`),
  CONSTRAINT `FK_m_product_mix_restricted_product_id_to_m_product_loan` FOREIGN KEY (`restricted_product_id`) REFERENCES `m_product_loan` (`id`),
  CONSTRAINT `FK_m_product_mix_product_id_to_m_product_loan` FOREIGN KEY (`product_id`) REFERENCES `m_product_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_product_mix: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_product_mix` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_product_mix` ENABLE KEYS */;


-- m_role
CREATE TABLE IF NOT EXISTS `m_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- m_role: ~1 rows (approximately)
/*!40000 ALTER TABLE `m_role` DISABLE KEYS */;
INSERT INTO `m_role` (`id`, `name`, `description`) VALUES
	(1, 'Super user', 'This role provides all application permissions.');
/*!40000 ALTER TABLE `m_role` ENABLE KEYS */;


-- m_role_permission
CREATE TABLE IF NOT EXISTS `m_role_permission` (
  `role_id` bigint(20) NOT NULL,
  `permission_id` bigint(20) NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `FK8DEDB04815CEC7AB` (`role_id`),
  KEY `FK8DEDB048103B544B` (`permission_id`),
  CONSTRAINT `FK8DEDB048103B544B` FOREIGN KEY (`permission_id`) REFERENCES `m_permission` (`id`),
  CONSTRAINT `FK8DEDB04815CEC7AB` FOREIGN KEY (`role_id`) REFERENCES `m_role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_role_permission: ~1 rows (approximately)
/*!40000 ALTER TABLE `m_role_permission` DISABLE KEYS */;
INSERT INTO `m_role_permission` (`role_id`, `permission_id`) VALUES
	(1, 1);
/*!40000 ALTER TABLE `m_role_permission` ENABLE KEYS */;


-- m_savings_account
CREATE TABLE IF NOT EXISTS `m_savings_account` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_no` varchar(20) NOT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `field_officer_id` bigint(20) DEFAULT NULL,
  `status_enum` smallint(5) NOT NULL DEFAULT '300',
  `account_type_enum` smallint(5) NOT NULL DEFAULT '1',
  `deposit_type_enum` smallint(5) NOT NULL DEFAULT '100',
  `submittedon_date` date NOT NULL,
  `submittedon_userid` bigint(20) DEFAULT NULL,
  `approvedon_date` date DEFAULT NULL,
  `approvedon_userid` bigint(20) DEFAULT NULL,
  `rejectedon_date` date DEFAULT NULL,
  `rejectedon_userid` bigint(20) DEFAULT NULL,
  `withdrawnon_date` date DEFAULT NULL,
  `withdrawnon_userid` bigint(20) DEFAULT NULL,
  `activatedon_date` date DEFAULT NULL,
  `activatedon_userid` bigint(20) DEFAULT NULL,
  `closedon_date` date DEFAULT NULL,
  `closedon_userid` bigint(20) DEFAULT NULL,
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `nominal_annual_interest_rate` decimal(19,6) NOT NULL,
  `interest_compounding_period_enum` smallint(5) NOT NULL,
  `interest_posting_period_enum` smallint(5) NOT NULL DEFAULT '4',
  `interest_calculation_type_enum` smallint(5) NOT NULL,
  `interest_calculation_days_in_year_type_enum` smallint(5) NOT NULL,
  `min_required_opening_balance` decimal(19,6) DEFAULT NULL,
  `lockin_period_frequency` decimal(19,6) DEFAULT NULL,
  `lockin_period_frequency_enum` smallint(5) DEFAULT NULL,
  `withdrawal_fee_for_transfer` tinyint(4) DEFAULT '1',
  `allow_overdraft` tinyint(1) NOT NULL DEFAULT '0',
  `overdraft_limit` decimal(19,6) DEFAULT NULL,
  `lockedin_until_date_derived` date DEFAULT NULL,
  `total_deposits_derived` decimal(19,6) DEFAULT NULL,
  `total_withdrawals_derived` decimal(19,6) DEFAULT NULL,
  `total_withdrawal_fees_derived` decimal(19,6) DEFAULT NULL,
  `total_fees_charge_derived` decimal(19,6) DEFAULT NULL,
  `total_penalty_charge_derived` decimal(19,6) DEFAULT NULL,
  `total_annual_fees_derived` decimal(19,6) DEFAULT NULL,
  `total_interest_earned_derived` decimal(19,6) DEFAULT NULL,
  `total_interest_posted_derived` decimal(19,6) DEFAULT NULL,
  `account_balance_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sa_account_no_UNIQUE` (`account_no`),
  UNIQUE KEY `sa_externalid_UNIQUE` (`external_id`),
  KEY `FKSA00000000000001` (`client_id`),
  KEY `FKSA00000000000002` (`group_id`),
  KEY `FKSA00000000000003` (`product_id`),
  CONSTRAINT `FKSA00000000000001` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FKSA00000000000002` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`id`),
  CONSTRAINT `FKSA00000000000003` FOREIGN KEY (`product_id`) REFERENCES `m_savings_product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_savings_account: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_savings_account` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_savings_account` ENABLE KEYS */;


-- m_savings_account_charge
CREATE TABLE IF NOT EXISTS `m_savings_account_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_id` bigint(20) NOT NULL,
  `charge_id` bigint(20) NOT NULL,
  `is_penalty` tinyint(1) NOT NULL DEFAULT '0',
  `charge_time_enum` smallint(5) NOT NULL,
  `charge_due_date` date DEFAULT NULL,
  `fee_on_month` smallint(5) DEFAULT NULL,
  `fee_on_day` smallint(5) DEFAULT NULL,
  `fee_interval` smallint(5) DEFAULT NULL,
  `charge_calculation_enum` smallint(5) NOT NULL,
  `calculation_percentage` decimal(19,6) DEFAULT NULL,
  `calculation_on_amount` decimal(19,6) DEFAULT NULL,
  `amount` decimal(19,6) NOT NULL,
  `amount_paid_derived` decimal(19,6) DEFAULT NULL,
  `amount_waived_derived` decimal(19,6) DEFAULT NULL,
  `amount_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `amount_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `is_paid_derived` tinyint(1) NOT NULL DEFAULT '0',
  `waived` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `charge_id` (`charge_id`),
  KEY `m_savings_account_charge_ibfk_2` (`savings_account_id`),
  CONSTRAINT `m_savings_account_charge_ibfk_1` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `m_savings_account_charge_ibfk_2` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_savings_account_charge: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_savings_account_charge` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_savings_account_charge` ENABLE KEYS */;


-- m_savings_account_charge_paid_by
CREATE TABLE IF NOT EXISTS `m_savings_account_charge_paid_by` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_transaction_id` bigint(20) NOT NULL,
  `savings_account_charge_id` bigint(20) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK__m_savings_account_transaction` (`savings_account_transaction_id`),
  KEY `FK__m_savings_account_charge` (`savings_account_charge_id`),
  CONSTRAINT `FK__m_savings_account_charge` FOREIGN KEY (`savings_account_charge_id`) REFERENCES `m_savings_account_charge` (`id`),
  CONSTRAINT `FK__m_savings_account_transaction` FOREIGN KEY (`savings_account_transaction_id`) REFERENCES `m_savings_account_transaction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_savings_account_charge_paid_by: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_savings_account_charge_paid_by` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_savings_account_charge_paid_by` ENABLE KEYS */;


-- m_savings_account_interest_rate_chart
CREATE TABLE IF NOT EXISTS `m_savings_account_interest_rate_chart` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_id` bigint(20) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `from_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKSAIRC00000000000001` (`savings_account_id`),
  CONSTRAINT `FKSAIRC00000000000001` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_savings_account_interest_rate_chart: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_savings_account_interest_rate_chart` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_savings_account_interest_rate_chart` ENABLE KEYS */;


-- m_savings_account_interest_rate_slab
CREATE TABLE IF NOT EXISTS `m_savings_account_interest_rate_slab` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_interest_rate_chart_id` bigint(20) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `period_type_enum` smallint(5) NOT NULL DEFAULT '1',
  `from_period` int(11) NOT NULL DEFAULT '0',
  `to_period` int(11) DEFAULT NULL,
  `amount_range_from` decimal(19,6) DEFAULT NULL,
  `amount_range_to` decimal(19,6) DEFAULT NULL,
  `annual_interest_rate` decimal(19,6) NOT NULL,
  `currency_code` varchar(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKSAIRS00000000000001` (`savings_account_interest_rate_chart_id`),
  CONSTRAINT `FKSAIRS00000000000001` FOREIGN KEY (`savings_account_interest_rate_chart_id`) REFERENCES `m_savings_account_interest_rate_chart` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_savings_account_interest_rate_slab: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_savings_account_interest_rate_slab` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_savings_account_interest_rate_slab` ENABLE KEYS */;


-- m_savings_account_transaction
CREATE TABLE IF NOT EXISTS `m_savings_account_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_id` bigint(20) NOT NULL,
  `office_id` bigint(20) NOT NULL,
  `payment_detail_id` bigint(20) DEFAULT NULL,
  `transaction_type_enum` smallint(5) NOT NULL,
  `is_reversed` tinyint(1) NOT NULL,
  `transaction_date` date NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `overdraft_amount_derived` decimal(19,6) DEFAULT NULL,
  `balance_end_date_derived` date DEFAULT NULL,
  `balance_number_of_days_derived` int(11) DEFAULT NULL,
  `running_balance_derived` decimal(19,6) DEFAULT NULL,
  `cumulative_balance_derived` decimal(19,6) DEFAULT NULL,
  `created_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKSAT0000000001` (`savings_account_id`),
  KEY `FK_m_savings_account_transaction_m_payment_detail` (`payment_detail_id`),
  KEY `FK_m_savings_account_transaction_m_office` (`office_id`),
  CONSTRAINT `FKSAT0000000001` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`),
  CONSTRAINT `FK_m_savings_account_transaction_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_m_savings_account_transaction_m_payment_detail` FOREIGN KEY (`payment_detail_id`) REFERENCES `m_payment_detail` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_savings_account_transaction: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_savings_account_transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_savings_account_transaction` ENABLE KEYS */;


-- m_savings_product
CREATE TABLE IF NOT EXISTS `m_savings_product` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `short_name` varchar(4) NOT NULL,
  `description` varchar(500) NOT NULL,
  `deposit_type_enum` smallint(5) NOT NULL DEFAULT '100',
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `nominal_annual_interest_rate` decimal(19,6) NOT NULL,
  `interest_compounding_period_enum` smallint(5) NOT NULL,
  `interest_posting_period_enum` smallint(5) NOT NULL DEFAULT '4',
  `interest_calculation_type_enum` smallint(5) NOT NULL,
  `interest_calculation_days_in_year_type_enum` smallint(5) NOT NULL,
  `min_required_opening_balance` decimal(19,6) DEFAULT NULL,
  `lockin_period_frequency` decimal(19,6) DEFAULT NULL,
  `lockin_period_frequency_enum` smallint(5) DEFAULT NULL,
  `accounting_type` smallint(5) NOT NULL,
  `withdrawal_fee_amount` decimal(19,6) DEFAULT NULL,
  `withdrawal_fee_type_enum` smallint(5) DEFAULT NULL,
  `withdrawal_fee_for_transfer` tinyint(4) DEFAULT '1',
  `allow_overdraft` tinyint(1) NOT NULL DEFAULT '0',
  `overdraft_limit` decimal(19,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sp_unq_name` (`name`),
  UNIQUE KEY `sp_unq_short_name` (`short_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_savings_product: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_savings_product` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_savings_product` ENABLE KEYS */;


-- m_savings_product_charge
CREATE TABLE IF NOT EXISTS `m_savings_product_charge` (
  `savings_product_id` bigint(20) NOT NULL,
  `charge_id` bigint(20) NOT NULL,
  PRIMARY KEY (`savings_product_id`,`charge_id`),
  KEY `charge_id` (`charge_id`),
  CONSTRAINT `m_savings_product_charge_ibfk_1` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `m_savings_product_charge_ibfk_2` FOREIGN KEY (`savings_product_id`) REFERENCES `m_savings_product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_savings_product_charge: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_savings_product_charge` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_savings_product_charge` ENABLE KEYS */;


-- m_staff
CREATE TABLE IF NOT EXISTS `m_staff` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_loan_officer` tinyint(1) NOT NULL DEFAULT '0',
  `office_id` bigint(20) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `display_name` varchar(100) NOT NULL,
  `mobile_no` varchar(50) DEFAULT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `organisational_role_enum` smallint(6) DEFAULT NULL,
  `organisational_role_parent_staff_id` bigint(20) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `display_name` (`display_name`),
  UNIQUE KEY `external_id_UNIQUE` (`external_id`),
  UNIQUE KEY `mobile_no_UNIQUE` (`mobile_no`),
  KEY `FK_m_staff_m_office` (`office_id`),
  CONSTRAINT `FK_m_staff_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_staff: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_staff` ENABLE KEYS */;


-- m_template
CREATE TABLE IF NOT EXISTS `m_template` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `text` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `entity` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_template: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_template` ENABLE KEYS */;


-- m_templatemappers
CREATE TABLE IF NOT EXISTS `m_templatemappers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `mapperkey` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `mapperorder` int(11) DEFAULT NULL,
  `mappervalue` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_templatemappers: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_templatemappers` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_templatemappers` ENABLE KEYS */;


-- m_template_m_templatemappers
CREATE TABLE IF NOT EXISTS `m_template_m_templatemappers` (
  `m_template_id` bigint(20) NOT NULL,
  `mappers_id` bigint(20) NOT NULL,
  UNIQUE KEY `mappers_id` (`mappers_id`),
  KEY `mappers_id_2` (`mappers_id`),
  KEY `m_template_id` (`m_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- m_template_m_templatemappers: ~0 rows (approximately)
/*!40000 ALTER TABLE `m_template_m_templatemappers` DISABLE KEYS */;
/*!40000 ALTER TABLE `m_template_m_templatemappers` ENABLE KEYS */;


-- m_working_days
CREATE TABLE IF NOT EXISTS `m_working_days` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `recurrence` varchar(100) DEFAULT NULL,
  `repayment_rescheduling_enum` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- m_working_days: ~1 rows (approximately)
/*!40000 ALTER TABLE `m_working_days` DISABLE KEYS */;
INSERT INTO `m_working_days` (`id`, `recurrence`, `repayment_rescheduling_enum`) VALUES
	(1, 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR,SA,SU', 2);
/*!40000 ALTER TABLE `m_working_days` ENABLE KEYS */;


-- ref_loan_transaction_processing_strategy
CREATE TABLE IF NOT EXISTS `ref_loan_transaction_processing_strategy` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(100) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ltp_strategy_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ref_loan_transaction_processing_strategy: ~7 rows (approximately)
/*!40000 ALTER TABLE `ref_loan_transaction_processing_strategy` DISABLE KEYS */;
INSERT INTO `ref_loan_transaction_processing_strategy` (`id`, `code`, `name`) VALUES
	(1, 'mifos-standard-strategy', 'Mifos style'),
	(2, 'heavensfamily-strategy', 'Heavensfamily'),
	(3, 'creocore-strategy', 'Creocore'),
	(4, 'rbi-india-strategy', 'RBI (India)'),
	(5, 'principal-interest-penalties-fees-order-strategy', 'Principal Interest Penalties Fees Order'),
	(6, 'interest-principal-penalties-fees-order-strategy', 'Interest Principal Penalties Fees Order'),
	(7, 'early-repayment-strategy', 'Early Repayment Strategy');
/*!40000 ALTER TABLE `ref_loan_transaction_processing_strategy` ENABLE KEYS */;


-- rpt_sequence
CREATE TABLE IF NOT EXISTS `rpt_sequence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- rpt_sequence: ~0 rows (approximately)
/*!40000 ALTER TABLE `rpt_sequence` DISABLE KEYS */;
/*!40000 ALTER TABLE `rpt_sequence` ENABLE KEYS */;


-- r_enum_value
CREATE TABLE IF NOT EXISTS `r_enum_value` (
  `enum_name` varchar(100) NOT NULL,
  `enum_id` int(11) NOT NULL,
  `enum_message_property` varchar(100) NOT NULL,
  `enum_value` varchar(100) NOT NULL,
  `enum_type` tinyint(1) NOT NULL,
  PRIMARY KEY (`enum_name`,`enum_id`),
  UNIQUE KEY `enum_message_property` (`enum_name`,`enum_message_property`),
  UNIQUE KEY `enum_value` (`enum_name`,`enum_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- r_enum_value: ~61 rows (approximately)
/*!40000 ALTER TABLE `r_enum_value` DISABLE KEYS */;
INSERT INTO `r_enum_value` (`enum_name`, `enum_id`, `enum_message_property`, `enum_value`, `enum_type`) VALUES
	('amortization_method_enum', 0, 'Equal principle payments', 'Equal principle payments', 0),
	('amortization_method_enum', 1, 'Equal installments', 'Equal installments', 0),
	('interest_calculated_in_period_enum', 0, 'Daily', 'Daily', 0),
	('interest_calculated_in_period_enum', 1, 'Same as repayment period', 'Same as repayment period', 0),
	('interest_method_enum', 0, 'Declining Balance', 'Declining Balance', 0),
	('interest_method_enum', 1, 'Flat', 'Flat', 0),
	('interest_period_frequency_enum', 2, 'Per month', 'Per month', 0),
	('interest_period_frequency_enum', 3, 'Per year', 'Per year', 0),
	('loan_status_id', 0, 'Invalid', 'Invalid', 0),
	('loan_status_id', 100, 'Submitted and awaiting approval', 'Submitted and awaiting approval', 0),
	('loan_status_id', 200, 'Approved', 'Approved', 0),
	('loan_status_id', 300, 'Active', 'Active', 0),
	('loan_status_id', 400, 'Withdrawn by client', 'Withdrawn by client', 0),
	('loan_status_id', 500, 'Rejected', 'Rejected', 0),
	('loan_status_id', 600, 'Closed', 'Closed', 0),
	('loan_status_id', 601, 'Written-Off', 'Written-Off', 0),
	('loan_status_id', 602, 'Rescheduled', 'Rescheduled', 0),
	('loan_status_id', 700, 'Overpaid', 'Overpaid', 0),
	('loan_transaction_strategy_id', 1, 'mifos-standard-strategy', 'Mifos style', 0),
	('loan_transaction_strategy_id', 2, 'heavensfamily-strategy', 'Heavensfamily', 0),
	('loan_transaction_strategy_id', 3, 'creocore-strategy', 'Creocore', 0),
	('loan_transaction_strategy_id', 4, 'rbi-india-strategy', 'RBI (India)', 0),
	('processing_result_enum', 0, 'invalid', 'Invalid', 0),
	('processing_result_enum', 1, 'processed', 'Processed', 0),
	('processing_result_enum', 2, 'awaiting.approval', 'Awaiting Approval', 0),
	('processing_result_enum', 3, 'rejected', 'Rejected', 0),
	('repayment_period_frequency_enum', 0, 'Days', 'Days', 0),
	('repayment_period_frequency_enum', 1, 'Weeks', 'Weeks', 0),
	('repayment_period_frequency_enum', 2, 'Months', 'Months', 0),
	('savings_transaction_type_enum', 1, 'deposit', 'deposit', 0),
	('savings_transaction_type_enum', 2, 'withdrawal', 'withdrawal', 1),
	('savings_transaction_type_enum', 3, 'Interest Posting', 'Interest Posting', 0),
	('savings_transaction_type_enum', 4, 'Withdrawal Fee', 'Withdrawal Fee', 1),
	('savings_transaction_type_enum', 5, 'Annual Fee', 'Annual Fee', 1),
	('savings_transaction_type_enum', 6, 'Waive Charge', 'Waive Charge', 0),
	('savings_transaction_type_enum', 7, 'Pay Charge', 'Pay Charge', 1),
	('savings_transaction_type_enum', 12, 'Initiate Transfer', 'Initiate Transfer', 0),
	('savings_transaction_type_enum', 13, 'Approve Transfer', 'Approve Transfer', 0),
	('savings_transaction_type_enum', 14, 'Withdraw Transfer', 'Withdraw Transfer', 0),
	('savings_transaction_type_enum', 15, 'Reject Transfer', 'Reject Transfer', 0),
	('savings_transaction_type_enum', 16, 'Written-Off', 'Written-Off', 0),
	('savings_transaction_type_enum', 17, 'Overdraft Interest', 'Overdraft Interest', 0),
	('status_enum', 0, 'Invalid', 'Invalid', 0),
	('status_enum', 100, 'Pending', 'Pending', 0),
	('status_enum', 300, 'Active', 'Active', 0),
	('status_enum', 600, 'Closed', 'Closed', 0),
	('term_period_frequency_enum', 0, 'Days', 'Days', 0),
	('term_period_frequency_enum', 1, 'Weeks', 'Weeks', 0),
	('term_period_frequency_enum', 2, 'Months', 'Months', 0),
	('term_period_frequency_enum', 3, 'Years', 'Years', 0),
	('transaction_type_enum', 1, 'Disbursement', 'Disbursement', 0),
	('transaction_type_enum', 2, 'Repayment', 'Repayment', 0),
	('transaction_type_enum', 3, 'Contra', 'Contra', 0),
	('transaction_type_enum', 4, 'Waive Interest', 'Waive Interest', 0),
	('transaction_type_enum', 5, 'Repayment At Disbursement', 'Repayment At Disbursement', 0),
	('transaction_type_enum', 6, 'Write-Off', 'Write-Off', 0),
	('transaction_type_enum', 7, 'Marked for Rescheduling', 'Marked for Rescheduling', 0),
	('transaction_type_enum', 8, 'Recovery Repayment', 'Recovery Repayment', 0),
	('transaction_type_enum', 9, 'Waive Charges', 'Waive Charges', 0),
	('transaction_type_enum', 10, 'Apply Charges', 'Apply Charges', 0),
	('transaction_type_enum', 11, 'Apply Interest', 'Apply Interest', 0);
/*!40000 ALTER TABLE `r_enum_value` ENABLE KEYS */;


-- scheduler_detail
CREATE TABLE IF NOT EXISTS `scheduler_detail` (
  `id` smallint(2) NOT NULL AUTO_INCREMENT,
  `is_suspended` tinyint(1) NOT NULL DEFAULT '0',
  `execute_misfired_jobs` tinyint(1) NOT NULL DEFAULT '1',
  `reset_scheduler_on_bootup` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- scheduler_detail: ~1 rows (approximately)
/*!40000 ALTER TABLE `scheduler_detail` DISABLE KEYS */;
INSERT INTO `scheduler_detail` (`id`, `is_suspended`, `execute_misfired_jobs`, `reset_scheduler_on_bootup`) VALUES
	(1, 0, 1, 1);
/*!40000 ALTER TABLE `scheduler_detail` ENABLE KEYS */;


-- schema_version
CREATE TABLE IF NOT EXISTS `schema_version` (
  `version_rank` int(11) NOT NULL,
  `installed_rank` int(11) NOT NULL,
  `version` varchar(50) NOT NULL,
  `description` varchar(200) NOT NULL,
  `type` varchar(20) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `checksum` int(11) DEFAULT NULL,
  `installed_by` varchar(100) NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int(11) NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`version`),
  KEY `schema_version_vr_idx` (`version_rank`),
  KEY `schema_version_ir_idx` (`installed_rank`),
  KEY `schema_version_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- schema_version: ~217 rows (approximately)
/*!40000 ALTER TABLE `schema_version` DISABLE KEYS */;
INSERT INTO `schema_version` (`version_rank`, `installed_rank`, `version`, `description`, `type`, `script`, `checksum`, `installed_by`, `installed_on`, `execution_time`, `success`) VALUES
	(1, 1, '1', 'mifosplatform-core-ddl-latest', 'SQL', 'V1__mifosplatform-core-ddl-latest.sql', -1957145051, 'root', '2014-05-06 16:10:35', 7029, 1),
	(10, 10, '10', 'interest-posting-fields-for-savings', 'SQL', 'V10__interest-posting-fields-for-savings.sql', -1133853485, 'root', '2014-05-06 16:10:41', 742, 1),
	(100, 100, '100', 'Group saving summary report', 'SQL', 'V100__Group_saving_summary_report.sql', -1635399448, 'root', '2014-05-06 16:11:34', 92, 1),
	(101, 101, '101', 'add mulitplesof to account transfers table', 'SQL', 'V101__add_mulitplesof_to_account_transfers_table.sql', -1162976022, 'root', '2014-05-06 16:11:34', 280, 1),
	(102, 102, '102', 'client attendance tables', 'SQL', 'V102__client_attendance_tables.sql', -45448019, 'root', '2014-05-06 16:11:35', 307, 1),
	(103, 103, '103', 'cluster support for batch jobs', 'SQL', 'V103__cluster_support_for_batch_jobs.sql', -781879007, 'root', '2014-05-06 16:11:36', 677, 1),
	(104, 104, '104', 'permissions for transfers', 'SQL', 'V104__permissions_for_transfers.sql', 653895919, 'root', '2014-05-06 16:11:36', 111, 1),
	(105, 105, '105', 'track loan transaction against office', 'SQL', 'V105__track_loan_transaction_against_office.sql', 785650440, 'root', '2014-05-06 16:11:37', 1028, 1),
	(106, 106, '106', 'more permissions for transfers', 'SQL', 'V106__more_permissions_for_transfers.sql', -1132691133, 'root', '2014-05-06 16:11:37', 45, 1),
	(107, 107, '107', 'datatable code mappings', 'SQL', 'V107__datatable_code_mappings.sql', 630737271, 'root', '2014-05-06 16:11:38', 300, 1),
	(108, 108, '108', 'client has transfer office', 'SQL', 'V108__client_has_transfer_office.sql', -1748734810, 'root', '2014-05-06 16:11:38', 511, 1),
	(109, 109, '109', 'account transfer withdrawal fee configuration', 'SQL', 'V109__account_transfer_withdrawal_fee_configuration.sql', -754569033, 'root', '2014-05-06 16:11:39', 411, 1),
	(11, 11, '11', 'add-payment-details', 'SQL', 'V11__add-payment-details.sql', 391380768, 'root', '2014-05-06 16:10:41', 548, 1),
	(110, 110, '110', 'group center close', 'SQL', 'V110__group_center_close.sql', -1261775365, 'root', '2014-05-06 16:11:39', 276, 1),
	(111, 111, '111', 'disable constraint approach for datatables by default', 'SQL', 'V111__disable_constraint_approach_for_datatables_by_default.sql', 2058257907, 'root', '2014-05-06 16:11:39', 38, 1),
	(112, 112, '111.1', 'set default transfers in suspense account for existing loan products', 'SQL', 'V111_1__set default_transfers_in_suspense_account_for_existing_loan_products.sql', 1907173791, 'root', '2014-05-06 16:11:40', 4, 1),
	(113, 113, '112', 'mixreport sql support', 'SQL', 'V112__mixreport_sql_support.sql', 1254859560, 'root', '2014-05-06 16:11:40', 428, 1),
	(114, 114, '113', 'track savings transaction against office', 'SQL', 'V113__track_savings_transaction_against_office.sql', -1390529632, 'root', '2014-05-06 16:11:41', 718, 1),
	(115, 115, '114', 'set default transfers in suspense account for existing savings products - Copy', 'SQL', 'V114__set_default_transfers_in_suspense_account_for_existing_savings_products - Copy.sql', 1518369372, 'root', '2014-05-06 16:11:41', 3, 1),
	(116, 116, '115', 'permissions for cache api', 'SQL', 'V115__permissions_for_cache_api.sql', 156437687, 'root', '2014-05-06 16:11:41', 127, 1),
	(117, 117, '116', 'track currency for journal entries', 'SQL', 'V116__track_currency_for_journal_entries.sql', 1109139399, 'root', '2014-05-06 16:11:42', 613, 1),
	(118, 118, '117', 'loan charge from savings', 'SQL', 'V117__loan_charge_from_savings.sql', 13633826, 'root', '2014-05-06 16:11:43', 737, 1),
	(119, 119, '118', 'savings charge', 'SQL', 'V118__savings_charge.sql', 899101813, 'root', '2014-05-06 16:11:43', 398, 1),
	(120, 120, '118.1', 'savings charge patch update', 'SQL', 'V118_1__savings_charge_patch_update.sql', 426133125, 'root', '2014-05-06 16:11:44', 591, 1),
	(121, 121, '118.2', 'product mapping delete duplicate fund source to account mappings', 'SQL', 'V118_2__product_mapping_delete_duplicate_fund_source_to_account_mappings.sql', 139468093, 'root', '2014-05-06 16:11:44', 3, 1),
	(122, 122, '118.3', 'permissions form propose and accept client transfers', 'SQL', 'V118_3__permissions_form_propose_and_accept_client_transfers.sql', 602708322, 'root', '2014-05-06 16:11:44', 38, 1),
	(123, 123, '118.4', 'reset default transfers in suspense account for existing savings products', 'SQL', 'V118_4__reset_default_transfers_in_suspense_account_for_existing_savings_products.sql', 1246865828, 'root', '2014-05-06 16:11:45', 5, 1),
	(124, 124, '118.5', 'batch job entry for pay savings charge', 'SQL', 'V118_5__batch_job_entry_for_pay_savings_charge.sql', -1477017272, 'root', '2014-05-06 16:11:45', 112, 1),
	(125, 125, '118.6', 'defaults for income from penalties for savings product', 'SQL', 'V118_6__defaults_for_income_from_penalties_for savings_product.sql', 255024118, 'root', '2014-05-06 16:11:45', 3, 1),
	(126, 126, '118.7', 'move withdrawal annual fee to charges', 'SQL', 'V118_7__move_withdrawal_annual_fee_to_charges.sql', 480656720, 'root', '2014-05-06 16:11:46', 1253, 1),
	(127, 127, '118.8', 'track overpayments seperately in loan transactions', 'SQL', 'V118_8__track_overpayments_seperately_in_loan_transactions.sql', 1684107411, 'root', '2014-05-06 16:11:47', 866, 1),
	(128, 128, '119', 'add template table', 'SQL', 'V119__add_template_table.sql', 1524629249, 'root', '2014-05-06 16:11:48', 595, 1),
	(12, 12, '12', 'add external id to couple of tables', 'SQL', 'V12__add_external_id_to_couple_of_tables.sql', 371833586, 'root', '2014-05-06 16:10:43', 1587, 1),
	(129, 129, '120', 'accounting running balance', 'SQL', 'V120__accounting_running_balance.sql', 746738547, 'root', '2014-05-06 16:11:49', 625, 1),
	(130, 130, '121', 'accounting running balance for organization', 'SQL', 'V121__accounting_running_balance_for_organization.sql', 1907762382, 'root', '2014-05-06 16:11:49', 395, 1),
	(131, 131, '122', 'recurring fee support for savings', 'SQL', 'V122__recurring_fee_support_for_savings.sql', -1538770236, 'root', '2014-05-06 16:11:50', 804, 1),
	(132, 132, '123', 'remove payment mode for savings', 'SQL', 'V123__remove_payment_mode_for_savings.sql', 1909778922, 'root', '2014-05-06 16:11:51', 414, 1),
	(133, 133, '124', 'added min max cap for charges', 'SQL', 'V124__added_min_max_cap_for_charges.sql', -1996899270, 'root', '2014-05-06 16:11:52', 848, 1),
	(134, 134, '125', 'added column for actual fee amount or percentage', 'SQL', 'V125__added_column_for_actual_fee_amount_or_percentage.sql', -87760502, 'root', '2014-05-06 16:11:52', 408, 1),
	(135, 135, '126', 'initial database structure for sms outbound', 'SQL', 'V126__initial_database_structure_for_sms_outbound.sql', -586195149, 'root', '2014-05-06 16:11:53', 563, 1),
	(136, 136, '127', 'mobile no fields', 'SQL', 'V127__mobile_no_fields.sql', -659228285, 'root', '2014-05-06 16:11:54', 969, 1),
	(137, 137, '128', 'added loan installment charge', 'SQL', 'V128__added_loan_installment_charge.sql', -1983585024, 'root', '2014-05-06 16:11:54', 461, 1),
	(138, 138, '129', 'client and group timeline', 'SQL', 'V129__client_and_group_timeline.sql', -1671377251, 'root', '2014-05-06 16:11:56', 1278, 1),
	(13, 13, '13', 'add group and client pending configuration', 'SQL', 'V13__add_group_and_client_pending_configuration.sql', 145878397, 'root', '2014-05-06 16:10:43', 78, 1),
	(139, 139, '130', 'calendar-history-table', 'SQL', 'V130__calendar-history-table.sql', -475045678, 'root', '2014-05-06 16:11:57', 227, 1),
	(140, 140, '131', 'holiday-status-column-and-permissions', 'SQL', 'V131__holiday-status-column-and-permissions.sql', -1387001593, 'root', '2014-05-06 16:11:58', 961, 1),
	(141, 141, '132', 'borrower cycle changes', 'SQL', 'V132__borrower_cycle_changes.sql', -355052428, 'root', '2014-05-06 16:11:58', 333, 1),
	(142, 142, '133', 'adding payment detail with journal entry', 'SQL', 'V133__adding_payment_detail_with_journal_entry.sql', 1975659943, 'root', '2014-05-06 16:11:59', 416, 1),
	(143, 143, '134', 'added column value on c configuration', 'SQL', 'V134__added_column_value_on_c_configuration.sql', -30626232, 'root', '2014-05-06 16:11:59', 321, 1),
	(144, 144, '134.1', 'submitted date updation for clients', 'SQL', 'V134_1__submitted_date_updation_for_clients.sql', 184599342, 'root', '2014-05-06 16:11:59', 6, 1),
	(145, 145, '134.2', 'permissions spelling correction', 'SQL', 'V134_2__permissions_spelling_correction.sql', 996960341, 'root', '2014-05-06 16:12:00', 45, 1),
	(146, 146, '135', 'added permission for undo written off', 'SQL', 'V135__added_permission_for_undo_written_off.sql', 1414936537, 'root', '2014-05-06 16:12:00', 63, 1),
	(147, 147, '136.1', 'update script strechy parameter', 'SQL', 'V136_1__update_script_strechy_parameter.sql', 633461657, 'root', '2014-05-06 16:12:00', 42, 1),
	(148, 148, '137', 'added is active column in m staff', 'SQL', 'V137__added_is_active_column_in_m_staff.sql', 1962782431, 'root', '2014-05-06 16:12:00', 231, 1),
	(149, 149, '138', 'add short name for m product loan and m savings product', 'SQL', 'V138__add_short_name_for_m_product_loan_and_m_savings_product.sql', -1526828084, 'root', '2014-05-06 16:12:02', 1347, 1),
	(150, 150, '139', 'default value for is active updated to true in m staff', 'SQL', 'V139__default_value_for_is_active_updated_to_true_in_m_staff.sql', 844329308, 'root', '2014-05-06 16:12:02', 303, 1),
	(14, 14, '14', 'rename status id to enum', 'SQL', 'V14__rename_status_id_to_enum.sql', 1958382098, 'root', '2014-05-06 16:10:44', 481, 1),
	(151, 151, '140', 'added loan charge status', 'SQL', 'V140__added_loan_charge_status.sql', 1209971905, 'root', '2014-05-06 16:12:03', 229, 1),
	(152, 152, '140.1', 'added payment detail id in ac gl journal entry', 'SQL', 'V140_1__added_payment_detail_id_in_ac_gl_journal_entry.sql', -214253481, 'root', '2014-05-06 16:12:03', 268, 1),
	(153, 153, '141', 'add early repayment strategy', 'SQL', 'V141__add_early_repayment_strategy.sql', 401969634, 'root', '2014-05-06 16:12:03', 197, 1),
	(154, 154, '142', 'read savingsaccount charge permission', 'SQL', 'V142__read_savingsaccount_charge_permission.sql', -1798083956, 'root', '2014-05-06 16:12:03', 42, 1),
	(155, 155, '143', 'create journalentry checker permission', 'SQL', 'V143__create_journalentry_checker_permission.sql', 227507002, 'root', '2014-05-06 16:12:04', 41, 1),
	(156, 156, '144', 'spelling mistake corrections', 'SQL', 'V144__spelling_mistake_corrections.sql', -778391100, 'root', '2014-05-06 16:12:04', 425, 1),
	(157, 157, '145', 'add force password reset in c configuration', 'SQL', 'V145__add_force_password_reset_in_c_configuration.sql', -662441756, 'root', '2014-05-06 16:12:05', 1070, 1),
	(158, 158, '146', 'tranche loans', 'SQL', 'V146__tranche_loans.sql', 989126672, 'root', '2014-05-06 16:12:07', 1762, 1),
	(159, 159, '147', 'tranche loans column name changes', 'SQL', 'V147__tranche_loans_column_name_changes.sql', -533159256, 'root', '2014-05-06 16:12:08', 358, 1),
	(160, 160, '148', 'overdraft changes', 'SQL', 'V148__overdraft_changes.sql', -1470217992, 'root', '2014-05-06 16:12:09', 1361, 1),
	(161, 161, '149', 'add created date savings transaction', 'SQL', 'V149__add_created_date_savings_transaction.sql', 137884095, 'root', '2014-05-06 16:12:10', 349, 1),
	(15, 15, '15', 'center permissions', 'SQL', 'V15__center_permissions.sql', 1124247014, 'root', '2014-05-06 16:10:44', 54, 1),
	(162, 162, '150', 'basic savings report', 'SQL', 'V150__basic_savings_report.sql', 2133891313, 'root', '2014-05-06 16:12:10', 397, 1),
	(163, 163, '151', 'add default savings account to client', 'SQL', 'V151__add_default_savings_account_to_client.sql', -2012873976, 'root', '2014-05-06 16:12:11', 232, 1),
	(164, 164, '152', 'added grace for over due', 'SQL', 'V152__added_grace_for_over_due.sql', 1917777205, 'root', '2014-05-06 16:12:11', 403, 1),
	(165, 165, '153', 'Insert missed permissions', 'SQL', 'V153__Insert_missed_permissions.sql', -1693091937, 'root', '2014-05-06 16:12:11', 79, 1),
	(166, 166, '154', 'aging details', 'SQL', 'V154__aging_details.sql', 1117759702, 'root', '2014-05-06 16:12:11', 41, 1),
	(167, 167, '155', 'stretchy into pentaho', 'SQL', 'V155__stretchy_into_pentaho.sql', -1836158085, 'root', '2014-05-06 16:12:12', 138, 1),
	(168, 168, '156', 'added loan saving txns pentaho', 'SQL', 'V156__added_loan_saving_txns_pentaho.sql', 1942570756, 'root', '2014-05-06 16:12:12', 50, 1),
	(169, 169, '157', 'overdue charge improvements', 'SQL', 'V157__overdue_charge_improvements.sql', -1267720651, 'root', '2014-05-06 16:12:12', 491, 1),
	(170, 170, '158', 'dashboard and navigation queries', 'SQL', 'V158__dashboard_and_navigation_queries.sql', -265915721, 'root', '2014-05-06 16:12:13', 55, 1),
	(171, 171, '159', 'add transaction id column m portfolio command source', 'SQL', 'V159__add_transaction_id_column_m_portfolio_command_source.sql', -1834626647, 'root', '2014-05-06 16:12:13', 195, 1),
	(16, 16, '16', 'drop min max column on loan table', 'SQL', 'V16__drop_min_max_column_on_loan_table.sql', -1497882087, 'root', '2014-05-06 16:10:44', 270, 1),
	(172, 172, '160', 'standing instruction changes', 'SQL', 'V160__standing_instruction_changes.sql', -2130923257, 'root', '2014-05-06 16:12:15', 1609, 1),
	(173, 173, '161', 'added accrual batch job', 'SQL', 'V161__added_accrual_batch_job.sql', -1558441026, 'root', '2014-05-06 16:12:15', 417, 1),
	(174, 174, '162', 'overdue charge batch job', 'SQL', 'V162__overdue_charge_batch_job.sql', -1213828784, 'root', '2014-05-06 16:12:15', 66, 1),
	(175, 175, '163', 'added npa for loans', 'SQL', 'V163__added_npa_for_loans.sql', -381581272, 'root', '2014-05-06 16:12:16', 646, 1),
	(176, 176, '164', 'fd and rd deposit tables', 'SQL', 'V164__fd_and_rd_deposit_tables.sql', -489803231, 'root', '2014-05-06 16:12:20', 3811, 1),
	(177, 177, '165', 'added permission for disburse to saving account', 'SQL', 'V165__added_permission_for_disburse_to_saving_account.sql', -2109143723, 'root', '2014-05-06 16:12:20', 129, 1),
	(178, 178, '166', 'added deposit amount to product term and preclosure', 'SQL', 'V166__added_deposit_amount_to_product_term_and_preclosure.sql', -2068527520, 'root', '2014-05-06 16:12:22', 1115, 1),
	(17, 17, '17', 'update stretchy reporting ddl', 'SQL', 'V17__update_stretchy_reporting_ddl.sql', 2040068410, 'root', '2014-05-06 16:10:46', 1365, 1),
	(18, 18, '18', 'update stretchy reporting reportSql', 'SQL', 'V18__update_stretchy_reporting_reportSql.sql', -170206095, 'root', '2014-05-06 16:10:46', 116, 1),
	(19, 19, '19', 'report maintenance permissions', 'SQL', 'V19__report_maintenance_permissions.sql', -1528956905, 'root', '2014-05-06 16:10:46', 59, 1),
	(2, 2, '2', 'mifosx-base-reference-data-utf8', 'SQL', 'V2__mifosx-base-reference-data-utf8.sql', 1316484475, 'root', '2014-05-06 16:10:35', 97, 1),
	(20, 20, '20', 'report maint perms really configuration', 'SQL', 'V20__report_maint_perms_really_configuration.sql', -402845015, 'root', '2014-05-06 16:10:46', 41, 1),
	(21, 21, '21', 'activation-permissions-for-clients', 'SQL', 'V21__activation-permissions-for-clients.sql', -569932376, 'root', '2014-05-06 16:10:47', 242, 1),
	(22, 22, '22', 'alter-group-for-consistency-add-permissions', 'SQL', 'V22__alter-group-for-consistency-add-permissions.sql', 578271556, 'root', '2014-05-06 16:10:48', 1087, 1),
	(23, 23, '23', 'remove-enable-disable-configuration-for-client-group-status', 'SQL', 'V23__remove-enable-disable-configuration-for-client-group-status.sql', -832390233, 'root', '2014-05-06 16:10:48', 521, 1),
	(24, 24, '24', 'add-group-client-foreign-key-constraint-in-loan-table', 'SQL', 'V24__add-group-client-foreign-key-constraint-in-loan-table.sql', -621897624, 'root', '2014-05-06 16:10:49', 286, 1),
	(25, 25, '25', 'update client reports for status and activation change', 'SQL', 'V25__update_client_reports_for_status_and_activation_change.sql', -1426943124, 'root', '2014-05-06 16:10:49', 44, 1),
	(26, 26, '26', 'add-support-for-withdrawal-fees-on-savings', 'SQL', 'V26__add-support-for-withdrawal-fees-on-savings.sql', -1955461568, 'root', '2014-05-06 16:10:50', 1010, 1),
	(27, 27, '27', 'add-loan-type-column-to-loan-table', 'SQL', 'V27__add-loan-type-column-to-loan-table.sql', -746287938, 'root', '2014-05-06 16:10:51', 420, 1),
	(28, 28, '28', 'accounting-abstractions-and-autoposting', 'SQL', 'V28__accounting-abstractions-and-autoposting.sql', -966431980, 'root', '2014-05-06 16:10:51', 664, 1),
	(29, 29, '29', 'add-support-for-annual-fees-on-savings', 'SQL', 'V29__add-support-for-annual-fees-on-savings.sql', 992227725, 'root', '2014-05-06 16:10:53', 1032, 1),
	(3, 3, '3', 'mifosx-permissions-and-authorisation-utf8', 'SQL', 'V3__mifosx-permissions-and-authorisation-utf8.sql', 1922951887, 'root', '2014-05-06 16:10:35', 93, 1),
	(30, 30, '30', 'add-referenceNumber-to-acc gl journal entry', 'SQL', 'V30__add-referenceNumber-to-acc_gl_journal_entry.sql', 2079970797, 'root', '2014-05-06 16:10:53', 413, 1),
	(31, 31, '31', 'drop-autopostings', 'SQL', 'V31__drop-autopostings.sql', 630501407, 'root', '2014-05-06 16:10:53', 70, 1),
	(32, 32, '32', 'associate-disassociate-clients-from-group-permissions', 'SQL', 'V32__associate-disassociate-clients-from-group-permissions.sql', 765311507, 'root', '2014-05-06 16:10:54', 46, 1),
	(33, 33, '33', 'drop unique check on stretchy report parameter', 'SQL', 'V33__drop_unique_check_on_stretchy_report_parameter.sql', -716768190, 'root', '2014-05-06 16:10:54', 689, 1),
	(34, 34, '34', 'add unique check on stretchy report parameter', 'SQL', 'V34__add_unique_check_on_stretchy_report_parameter.sql', -1989718961, 'root', '2014-05-06 16:10:55', 204, 1),
	(35, 35, '35', 'add hierarchy column for acc gl account', 'SQL', 'V35__add_hierarchy_column_for_acc_gl_account.sql', -1387013309, 'root', '2014-05-06 16:10:55', 427, 1),
	(36, 36, '36', 'add tag id column for acc gl account', 'SQL', 'V36__add_tag_id_column_for_acc_gl_account.sql', -620418591, 'root', '2014-05-06 16:10:56', 406, 1),
	(37, 37, '37', 'add-center-group-collection-sheet-permissions', 'SQL', 'V37__add-center-group-collection-sheet-permissions.sql', -1157429270, 'root', '2014-05-06 16:10:56', 57, 1),
	(38, 38, '38', 'add-group-summary-details-report', 'SQL', 'V38__add-group-summary-details-report.sql', -1018394665, 'root', '2014-05-06 16:10:56', 130, 1),
	(39, 39, '39', 'payment-channels-updates', 'SQL', 'V39__payment-channels-updates.sql', -1005512239, 'root', '2014-05-06 16:10:59', 2026, 1),
	(4, 4, '4', 'mifosx-core-reports-utf8', 'SQL', 'V4__mifosx-core-reports-utf8.sql', -934709187, 'root', '2014-05-06 16:10:36', 539, 1),
	(40, 40, '40', 'add permissions for accounting rule', 'SQL', 'V40__add_permissions_for_accounting_rule.sql', 1514233058, 'root', '2014-05-06 16:10:59', 318, 1),
	(41, 41, '41', 'group-summary-reports', 'SQL', 'V41__group-summary-reports.sql', 263779795, 'root', '2014-05-06 16:10:59', 168, 1),
	(42, 42, '42', 'Add default value for id for acc accounting rule', 'SQL', 'V42__Add_default_value_for_id_for_acc_accounting_rule.sql', 1068680120, 'root', '2014-05-06 16:11:00', 359, 1),
	(43, 43, '43', 'accounting-for-savings', 'SQL', 'V43__accounting-for-savings.sql', 1965510021, 'root', '2014-05-06 16:11:01', 1107, 1),
	(44, 44, '44', 'document-increase-size-of-column-type', 'SQL', 'V44__document-increase-size-of-column-type.sql', 1264142829, 'root', '2014-05-06 16:11:02', 665, 1),
	(45, 45, '45', 'create acc rule tags table', 'SQL', 'V45__create_acc_rule_tags_table.sql', -307868244, 'root', '2014-05-06 16:11:03', 385, 1),
	(46, 46, '46', 'extend datatables api', 'SQL', 'V46__extend_datatables_api.sql', 297544230, 'root', '2014-05-06 16:11:03', 37, 1),
	(47, 47, '47', 'staff-hierarchy-link-to-users', 'SQL', 'V47__staff-hierarchy-link-to-users.sql', 480254198, 'root', '2014-05-06 16:11:04', 991, 1),
	(48, 48, '48', 'adding-S3-Support', 'SQL', 'V48__adding-S3-Support.sql', -280798781, 'root', '2014-05-06 16:11:06', 1990, 1),
	(49, 49, '49', 'track-loan-charge-payment-transactions', 'SQL', 'V49__track-loan-charge-payment-transactions.sql', 170618680, 'root', '2014-05-06 16:11:06', 189, 1),
	(5, 5, '5', 'update-savings-product-and-account-tables', 'SQL', 'V5__update-savings-product-and-account-tables.sql', 1171300485, 'root', '2014-05-06 16:10:37', 747, 1),
	(50, 50, '50', 'add-grace-settings-to-loan-product', 'SQL', 'V50__add-grace-settings-to-loan-product.sql', 188244658, 'root', '2014-05-06 16:11:07', 757, 1),
	(51, 51, '51', 'track-additional-details-related-to-installment-performance', 'SQL', 'V51__track-additional-details-related-to-installment-performance.sql', 2012793946, 'root', '2014-05-06 16:11:08', 762, 1),
	(52, 52, '52', 'add boolean support cols to acc accounting rule', 'SQL', 'V52__add_boolean_support_cols_to_acc_accounting_rule.sql', 961668575, 'root', '2014-05-06 16:11:09', 403, 1),
	(53, 53, '53', 'track-advance-and-late-payments-on-installment', 'SQL', 'V53__track-advance-and-late-payments-on-installment.sql', -230737076, 'root', '2014-05-06 16:11:09', 194, 1),
	(54, 54, '54', 'charge-to-income-account-mappings', 'SQL', 'V54__charge-to-income-account-mappings.sql', 2064168495, 'root', '2014-05-06 16:11:09', 194, 1),
	(55, 55, '55', 'add-additional-transaction-processing-strategies', 'SQL', 'V55__add-additional-transaction-processing-strategies.sql', 1186305896, 'root', '2014-05-06 16:11:10', 518, 1),
	(56, 56, '56', 'track-overpaid-amount-on-loans', 'SQL', 'V56__track-overpaid-amount-on-loans.sql', 1455634018, 'root', '2014-05-06 16:11:11', 549, 1),
	(57, 57, '57', 'add default values to debit and credit accounts acc accounting rule', 'SQL', 'V57__add_default_values_to_debit_and_credit_accounts_acc_accounting_rule.sql', 1936034654, 'root', '2014-05-06 16:11:11', 210, 1),
	(58, 58, '58', 'create-holiday-tables changed', 'SQL', 'V58__create-holiday-tables_changed.sql', 878594707, 'root', '2014-05-06 16:11:11', 361, 1),
	(59, 59, '59', 'add group roles schema and permissions', 'SQL', 'V59__add_group_roles_schema_and_permissions.sql', 2139634800, 'root', '2014-05-06 16:11:12', 251, 1),
	(6, 6, '6', 'add min max principal column to loan', 'SQL', 'V6__add_min_max_principal_column_to_loan.sql', 21414779, 'root', '2014-05-06 16:10:38', 861, 1),
	(60, 60, '60', 'quipo dashboard reports', 'SQL', 'V60__quipo_dashboard_reports.sql', -1414014218, 'root', '2014-05-06 16:11:12', 67, 1),
	(61, 61, '61', 'txn running balance example', 'SQL', 'V61__txn_running_balance_example.sql', -1186179870, 'root', '2014-05-06 16:11:12', 51, 1),
	(62, 62, '62', 'add staff id to m client changed', 'SQL', 'V62__add_staff_id_to_m_client_changed.sql', -903717279, 'root', '2014-05-06 16:11:13', 412, 1),
	(63, 63, '63', 'add sync disbursement with meeting column to loan', 'SQL', 'V63__add_sync_disbursement_with_meeting_column_to_loan.sql', 1706011840, 'root', '2014-05-06 16:11:13', 238, 1),
	(64, 64, '64', 'add permission for assign staff', 'SQL', 'V64__add_permission_for_assign_staff.sql', -1938102414, 'root', '2014-05-06 16:11:13', 329, 1),
	(65, 65, '65', 'fix rupee symbol issues', 'SQL', 'V65__fix_rupee_symbol_issues.sql', 581612224, 'root', '2014-05-06 16:11:14', 59, 1),
	(66, 66, '66', 'client close functionality', 'SQL', 'V66__client_close_functionality.sql', 225242657, 'root', '2014-05-06 16:11:15', 965, 1),
	(67, 67, '67', 'loans in advance table', 'SQL', 'V67__loans_in_advance_table.sql', -2001051496, 'root', '2014-05-06 16:11:15', 155, 1),
	(68, 68, '68', 'quipo dashboard reports updated', 'SQL', 'V68__quipo_dashboard_reports_updated.sql', -1241469930, 'root', '2014-05-06 16:11:16', 224, 1),
	(69, 69, '69', 'loans in advance initialise', 'SQL', 'V69__loans_in_advance_initialise.sql', -1961764720, 'root', '2014-05-06 16:11:16', 58, 1),
	(7, 7, '7', 'remove read makerchecker permission', 'SQL', 'V7__remove_read_makerchecker_permission.sql', -335430825, 'root', '2014-05-06 16:10:38', 43, 1),
	(70, 70, '70', 'quipo program detail query fix', 'SQL', 'V70__quipo_program_detail_query_fix.sql', 961289260, 'root', '2014-05-06 16:11:16', 55, 1),
	(71, 71, '71', 'insert reschedule repayment to configuration', 'SQL', 'V71__insert_reschedule_repayment_to_configuration.sql', -1148306529, 'root', '2014-05-06 16:11:16', 42, 1),
	(72, 72, '72', 'add m loan counter changes', 'SQL', 'V72__add_m_loan_counter_changes.sql', 201544058, 'root', '2014-05-06 16:11:17', 583, 1),
	(73, 73, '73', 'add repayments rescheduled to and processed column to holiday', 'SQL', 'V73__add_repayments_rescheduled_to_and_processed_column_to_holiday.sql', -1946338033, 'root', '2014-05-06 16:11:17', 240, 1),
	(74, 74, '74', 'alter m loan counter table add group', 'SQL', 'V74__alter_m_loan_counter_table_add_group.sql', -889985683, 'root', '2014-05-06 16:11:18', 330, 1),
	(75, 75, '75', 'add reschedule-repayments-on-holidays to configuration', 'SQL', 'V75__add_reschedule-repayments-on-holidays_to_configuration.sql', 1328301697, 'root', '2014-05-06 16:11:18', 49, 1),
	(76, 76, '76', 'rename permission grouping', 'SQL', 'V76__rename_permission_grouping.sql', 1717580945, 'root', '2014-05-06 16:11:18', 46, 1),
	(77, 77, '77', 'alter m product loan changes', 'SQL', 'V77__alter_m_product_loan_changes.sql', 677013677, 'root', '2014-05-06 16:11:18', 209, 1),
	(78, 78, '78', 'breakdown portfolio grouping', 'SQL', 'V78__breakdown_portfolio_grouping.sql', -1385954232, 'root', '2014-05-06 16:11:19', 46, 1),
	(79, 79, '79', 'schedule jobs tables', 'SQL', 'V79__schedule_jobs_tables.sql', 339707179, 'root', '2014-05-06 16:11:19', 311, 1),
	(8, 8, '8', 'deposit-transaction-permissions-if-they-exist', 'SQL', 'V8__deposit-transaction-permissions-if-they-exist.sql', -1507997551, 'root', '2014-05-06 16:10:38', 6, 1),
	(80, 80, '80', 'schedule jobs tables updates', 'SQL', 'V80__schedule_jobs_tables_updates.sql', -152869205, 'root', '2014-05-06 16:11:21', 2005, 1),
	(81, 81, '81', 'savings related changes', 'SQL', 'V81__savings_related_changes.sql', 285284658, 'root', '2014-05-06 16:11:24', 2366, 1),
	(82, 82, '82', 'schedule jobs tables updates for running status', 'SQL', 'V82__schedule_jobs_tables_updates_for_running_status.sql', -1029370098, 'root', '2014-05-06 16:11:25', 841, 1),
	(83, 83, '83', 'non-working-days-table', 'SQL', 'V83__non-working-days-table.sql', -1092480574, 'root', '2014-05-06 16:11:25', 295, 1),
	(84, 84, '84', 'undo savings transaction permission', 'SQL', 'V84__undo_savings_transaction_permission.sql', 1857641857, 'root', '2014-05-06 16:11:25', 117, 1),
	(85, 85, '85', 'product mix related changes', 'SQL', 'V85__product_mix_related_changes.sql', -740767169, 'root', '2014-05-06 16:11:26', 632, 1),
	(86, 86, '86', 'update-working-days', 'SQL', 'V86__update-working-days.sql', 1266232028, 'root', '2014-05-06 16:11:26', 155, 1),
	(87, 87, '87', 'add permission for scheduler', 'SQL', 'V87__add_permission_for_scheduler.sql', -575950289, 'root', '2014-05-06 16:11:27', 122, 1),
	(88, 88, '88', 'added update constrain for scheduler jobs', 'SQL', 'V88__added_update_constrain_for_scheduler_jobs.sql', 1579070736, 'root', '2014-05-06 16:11:27', 460, 1),
	(89, 89, '89', 'added scheduler group', 'SQL', 'V89__added_scheduler_group.sql', -1538207332, 'root', '2014-05-06 16:11:28', 382, 1),
	(9, 9, '9', 'add min max constraint column to loan loanproduct', 'SQL', 'V9__add_min_max_constraint_column_to_loan_loanproduct.sql', -2103326932, 'root', '2014-05-06 16:10:40', 1520, 1),
	(90, 90, '90', 'client performance history reports', 'SQL', 'V90__client_performance_history_reports.sql', 35589718, 'root', '2014-05-06 16:11:28', 109, 1),
	(91, 91, '91', 'apply annual fees permission', 'SQL', 'V91__apply_annual_fees_permission.sql', 440351308, 'root', '2014-05-06 16:11:28', 108, 1),
	(92, 92, '91.1', 'configuration settings for holiday and non workingday', 'SQL', 'V91_1__configuration_settings_for_holiday_and_non_workingday.sql', -429561096, 'root', '2014-05-06 16:11:28', 102, 1),
	(93, 93, '92', 'group center assign staff permission', 'SQL', 'V92__group_center_assign_staff_permission.sql', -1557846330, 'root', '2014-05-06 16:11:29', 103, 1),
	(94, 94, '93', 'loan transaction external id', 'SQL', 'V93__loan_transaction_external_id.sql', 987684239, 'root', '2014-05-06 16:11:29', 365, 1),
	(95, 95, '94', 'added savings accont type', 'SQL', 'V94__added_savings_accont type.sql', 623078091, 'root', '2014-05-06 16:11:30', 438, 1),
	(96, 96, '95', 'batch job postInterest', 'SQL', 'V95__batch_job_postInterest.sql', -1484077135, 'root', '2014-05-06 16:11:30', 106, 1),
	(97, 97, '96', 'savings accounts transfers table', 'SQL', 'V96__savings_accounts_transfers_table.sql', -1447275289, 'root', '2014-05-06 16:11:31', 1144, 1),
	(98, 98, '97', 'add permission for adjust savings transaction', 'SQL', 'V97__add_permission_for_adjust_savings_transaction.sql', -2045732265, 'root', '2014-05-06 16:11:31', 54, 1),
	(99, 99, '98', 'added currency roundof for multipleof', 'SQL', 'V98__added_currency_roundof_for_multipleof.sql', -131804848, 'root', '2014-05-06 16:11:34', 2266, 1);
/*!40000 ALTER TABLE `schema_version` ENABLE KEYS */;


-- sms_messages_outbound
CREATE TABLE IF NOT EXISTS `sms_messages_outbound` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` bigint(20) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `staff_id` bigint(20) DEFAULT NULL,
  `status_enum` int(5) NOT NULL DEFAULT '100',
  `mobile_no` varchar(50) NOT NULL,
  `message` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKGROUP000000001` (`group_id`),
  KEY `FKCLIENT00000001` (`client_id`),
  KEY `FKSTAFF000000001` (`staff_id`),
  CONSTRAINT `FKGROUP000000001` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`id`),
  CONSTRAINT `FKCLIENT00000001` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FKSTAFF000000001` FOREIGN KEY (`staff_id`) REFERENCES `m_staff` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- sms_messages_outbound: ~0 rows (approximately)
/*!40000 ALTER TABLE `sms_messages_outbound` DISABLE KEYS */;
/*!40000 ALTER TABLE `sms_messages_outbound` ENABLE KEYS */;


-- stretchy_parameter
CREATE TABLE IF NOT EXISTS `stretchy_parameter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter_name` varchar(45) NOT NULL,
  `parameter_variable` varchar(45) DEFAULT NULL,
  `parameter_label` varchar(45) NOT NULL,
  `parameter_displayType` varchar(45) NOT NULL,
  `parameter_FormatType` varchar(10) NOT NULL,
  `parameter_default` varchar(45) NOT NULL,
  `special` varchar(1) DEFAULT NULL,
  `selectOne` varchar(1) DEFAULT NULL,
  `selectAll` varchar(1) DEFAULT NULL,
  `parameter_sql` text,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`parameter_name`),
  KEY `fk_stretchy_parameter_001_idx` (`parent_id`),
  CONSTRAINT `fk_stretchy_parameter_001` FOREIGN KEY (`parent_id`) REFERENCES `stretchy_parameter` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1006 DEFAULT CHARSET=utf8;

-- stretchy_parameter: ~15 rows (approximately)
/*!40000 ALTER TABLE `stretchy_parameter` DISABLE KEYS */;
INSERT INTO `stretchy_parameter` (`id`, `parameter_name`, `parameter_variable`, `parameter_label`, `parameter_displayType`, `parameter_FormatType`, `parameter_default`, `special`, `selectOne`, `selectAll`, `parameter_sql`, `parent_id`) VALUES
	(1, 'startDateSelect', 'startDate', 'startDate', 'date', 'date', 'today', NULL, NULL, NULL, NULL, NULL),
	(2, 'endDateSelect', 'endDate', 'endDate', 'date', 'date', 'today', NULL, NULL, NULL, NULL, NULL),
	(3, 'obligDateTypeSelect', 'obligDateType', 'obligDateType', 'select', 'number', '0', NULL, NULL, NULL, 'select * from\r\n(select 1 as id, "Closed" as `name` union all\r\nselect 2, "Disbursal" ) x\r\norder by x.`id`', NULL),
	(5, 'OfficeIdSelectOne', 'officeId', 'Office', 'select', 'number', '0', NULL, 'Y', NULL, 'select id, \r\nconcat(substring("........................................", 1, \r\n   \n\n((LENGTH(`hierarchy`) - LENGTH(REPLACE(`hierarchy`, \'.\', \'\')) - 1) * 4)), \r\n   `name`) as tc\r\nfrom m_office\r\nwhere hierarchy like concat\n\n(\'${currentUserHierarchy}\', \'%\')\r\norder by hierarchy', NULL),
	(6, 'loanOfficerIdSelectAll', 'loanOfficerId', 'Loan Officer', 'select', 'number', '0', NULL, NULL, 'Y', '(select lo.id, lo.display_name as `Name` \r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\njoin m_staff lo on lo.office_id = ounder.id\r\nwhere lo.is_loan_officer = true\r\nand o.id = ${officeId})\r\nunion all\r\n(select -10, \'-\')\r\norder by 2', 5),
	(10, 'currencyIdSelectAll', 'currencyId', 'Currency', 'select', 'number', '0', NULL, NULL, 'Y', 'select `code`, `name`\r\nfrom m_organisation_currency\r\norder by `code`', NULL),
	(20, 'fundIdSelectAll', 'fundId', 'Fund', 'select', 'number', '0', NULL, NULL, 'Y', '(select id, `name`\r\nfrom m_fund)\r\nunion all\r\n(select -10, \'-\')\r\norder by 2', NULL),
	(25, 'loanProductIdSelectAll', 'loanProductId', 'Product', 'select', 'number', '0', NULL, NULL, 'Y', 'select p.id, p.`name`\r\nfrom m_product_loan p\r\nwhere (p.currency_code = \'${currencyId}\' or \'-1\'= \'${currencyId}\')\r\norder by 2', 10),
	(26, 'loanPurposeIdSelectAll', 'loanPurposeId', 'Loan Purpose', 'select', 'number', '0', NULL, NULL, 'Y', 'select -10 as id, \'-\' as code_value\r\nunion all\r\nselect * from (select v.id, v.code_value\r\nfrom m_code c\r\njoin m_code_value v on v.code_id = c.id\r\nwhere c.code_name = "loanPurpose"\r\norder by v.order_position)  x', NULL),
	(100, 'parTypeSelect', 'parType', 'parType', 'select', 'number', '0', NULL, NULL, NULL, 'select * from\r\n(select 1 as id, "Principal Only" as `name` union all\r\nselect 2, "Principal + Interest" union all\r\nselect 3, "Principal + Interest + Fees" union all\r\nselect 4, "Principal + Interest + Fees + Penalties") x\r\norder by x.`id`', NULL),
	(1001, 'FullReportList', NULL, 'n/a', 'n/a', 'n/a', 'n/a', 'Y', NULL, NULL, 'select  r.id as report_id, r.report_name, r.report_type, r.report_subtype, r.report_category,\nrp.id as parameter_id, rp.report_parameter_name, p.parameter_name\n  from stretchy_report r\n  left join stretchy_report_parameter rp on rp.report_id = r.id \n  left join stretchy_parameter p on p.id = rp.parameter_id\n  where r.use_report is true\n  and exists\n  ( select \'f\'\n  from m_appuser_role ur \n  join m_role r on r.id = ur.role_id\n  join m_role_permission rp on rp.role_id = r.id\n  join m_permission p on p.id = rp.permission_id\n  where ur.appuser_id = ${currentUserId}\n  and (p.code in (\'ALL_FUNCTIONS_READ\', \'ALL_FUNCTIONS\') or p.code = concat("READ_", r.report_name)) )\n  order by r.report_category, r.report_name, rp.id', NULL),
	(1002, 'FullParameterList', NULL, 'n/a', 'n/a', 'n/a', 'n/a', 'Y', NULL, NULL, 'select sp.parameter_name, sp.parameter_variable, sp.parameter_label, sp.parameter_displayType, \r sp.parameter_FormatType, sp.parameter_default, sp.selectOne,  sp.selectAll, spp.parameter_name as parentParameterName\r from stretchy_parameter sp\r left join stretchy_parameter spp on spp.id = sp.parent_id\r where sp.special is null\r and exists \r 	(select \'f\' \r 	from stretchy_report sr\r 	join stretchy_report_parameter srp on srp.report_id = sr.id\r 	where sr.report_name in(${reportListing})\r 	and srp.parameter_id = sp.id\r 	)\r order by sp.id', NULL),
	(1003, 'reportCategoryList', NULL, 'n/a', 'n/a', 'n/a', 'n/a', 'Y', NULL, NULL, 'select  r.id as report_id, r.report_name, r.report_type, r.report_subtype, r.report_category,\n  rp.id as parameter_id, rp.report_parameter_name, p.parameter_name\n  from stretchy_report r\n  left join stretchy_report_parameter rp on rp.report_id = r.id\n  left join stretchy_parameter p on p.id = rp.parameter_id\n  where r.report_category = \'${reportCategory}\'\n  and r.use_report is true\n  and exists\n  (select \'f\'\n  from m_appuser_role ur \n  join m_role r on r.id = ur.role_id\n  join m_role_permission rp on rp.role_id = r.id\n  join m_permission p on p.id = rp.permission_id\n  where ur.appuser_id = ${currentUserId}\n  and (p.code in (\'ALL_FUNCTIONS_READ\', \'ALL_FUNCTIONS\') or p.code = concat("READ_", r.report_name)) )\n  order by r.report_category, r.report_name, rp.id', NULL),
	(1004, 'selectAccount', 'accountNo', 'Enter Account No', 'text', 'string', 'n/a', NULL, NULL, NULL, NULL, NULL),
	(1005, 'savingsProductIdSelectAll', 'savingsProductId', 'Product', 'select', 'number', '0', NULL, NULL, 'Y', 'select p.id, p.`name`\r\nfrom m_savings_product p\r\norder by 2', NULL);
/*!40000 ALTER TABLE `stretchy_parameter` ENABLE KEYS */;


-- stretchy_report
CREATE TABLE IF NOT EXISTS `stretchy_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_name` varchar(100) NOT NULL,
  `report_type` varchar(20) NOT NULL,
  `report_subtype` varchar(20) DEFAULT NULL,
  `report_category` varchar(45) DEFAULT NULL,
  `report_sql` text,
  `description` text,
  `core_report` tinyint(1) DEFAULT '0',
  `use_report` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `report_name_UNIQUE` (`report_name`)
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=utf8;

-- stretchy_report: ~53 rows (approximately)
/*!40000 ALTER TABLE `stretchy_report` DISABLE KEYS */;
INSERT INTO `stretchy_report` (`id`, `report_name`, `report_type`, `report_subtype`, `report_category`, `report_sql`, `description`, `core_report`, `use_report`) VALUES
	(1, 'Client Listing', 'Table', NULL, 'Client', 'select \nconcat(repeat("..",   \n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\n c.account_no as "Client Account No.",  \nc.display_name as "Name",  \nr.enum_message_property as "Status",\nc.activation_date as "Activation", c.external_id as "External Id"\nfrom m_office o \njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_client c on c.office_id = ounder.id\nleft join r_enum_value r on r.enum_name = \'status_enum\' and r.enum_id = c.status_enum\nwhere o.id = ${officeId}\norder by ounder.hierarchy, c.account_no', 'Individual Client Report\r\n\r\nLists the small number of defined fields on the client table.  Would expect to copy this \n\nreport and add any \'one to one\' additional data for specific tenant needs.\r\n\r\nCan be run for any size MFI but you\'d expect it only to be run within a branch for \n\nlarger ones.  Depending on how many columns are displayed, there is probably is a limit of about 20/50k clients returned for html display (export to excel doesn\'t \n\nhave that client browser/memory impact).', 1, 1),
	(2, 'Client Loans Listing', 'Table', NULL, 'Client', 'select \nconcat(repeat("..",   \n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch", c.account_no as "Client Account No.", \nc.display_name as "Name",\nr.enum_message_property as "Client Status",\nlo.display_name as "Loan Officer", l.account_no as "Loan Account No.", l.external_id as "External Id", p.name as Loan, st.enum_message_property as "Status",  \nf.`name` as Fund, purp.code_value as "Loan Purpose",\nifnull(cur.display_symbol, l.currency_code) as Currency,  \nl.principal_amount, l.arrearstolerance_amount as "Arrears Tolerance Amount",\nl.number_of_repayments as "Expected No. Repayments", \nl.annual_nominal_interest_rate as " Annual Nominal Interest Rate", \nl.nominal_interest_rate_per_period as "Nominal Interest Rate Per Period",\nipf.enum_message_property as "Interest Rate Frequency",\nim.enum_message_property as "Interest Method",\nicp.enum_message_property as "Interest Calculated in Period",\nl.term_frequency as "Term Frequency",\ntf.enum_message_property as "Term Frequency Period",\nl.repay_every as "Repayment Frequency",\nrf.enum_message_property as "Repayment Frequency Period",\nam.enum_message_property as "Amortization",\nl.total_charges_due_at_disbursement_derived as "Total Charges Due At Disbursement",\ndate(l.submittedon_date) as Submitted, date(l.approvedon_date) Approved, l.expected_disbursedon_date As "Expected Disbursal",\ndate(l.expected_firstrepaymenton_date) as "Expected First Repayment", \ndate(l.interest_calculated_from_date) as "Interest Calculated From" ,\ndate(l.disbursedon_date) as Disbursed, \ndate(l.expected_maturedon_date) "Expected Maturity",\ndate(l.maturedon_date) as "Matured On", date(l.closedon_date) as Closed,\ndate(l.rejectedon_date) as Rejected, date(l.rescheduledon_date) as Rescheduled, \ndate(l.withdrawnon_date) as Withdrawn, date(l.writtenoffon_date) "Written Off"\nfrom m_office o \njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_client c on c.office_id = ounder.id\nleft join r_enum_value r on r.enum_name = \'status_enum\' \n and r.enum_id = c.status_enum\nleft join m_loan l on l.client_id = c.id\nleft join m_staff lo on lo.id = l.loan_officer_id\nleft join m_product_loan p on p.id = l.product_id\nleft join m_fund f on f.id = l.fund_id\nleft join r_enum_value st on st.enum_name = "loan_status_id" and st.enum_id = l.loan_status_id\nleft join r_enum_value ipf on ipf.enum_name = "interest_period_frequency_enum" \n and ipf.enum_id = l.interest_period_frequency_enum\nleft join r_enum_value im on im.enum_name = "interest_method_enum" \n and im.enum_id = l.interest_method_enum\nleft join r_enum_value tf on tf.enum_name = "term_period_frequency_enum" \n and tf.enum_id = l.term_period_frequency_enum\nleft join r_enum_value icp on icp.enum_name = "interest_calculated_in_period_enum" \n and icp.enum_id = l.interest_calculated_in_period_enum\nleft join r_enum_value rf on rf.enum_name = "repayment_period_frequency_enum" \n and rf.enum_id = l.repayment_period_frequency_enum\nleft join r_enum_value am on am.enum_name = "amortization_method_enum" \n and am.enum_id = l.amortization_method_enum\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\nleft join m_currency cur on cur.code = l.currency_code\nwhere o.id = ${officeId}\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\norder by ounder.hierarchy, 2 , l.id', 'Individual Client Report\r\n\r\nPretty \n\nwide report that lists the basic details of client loans.  \r\n\r\nCan be run for any size MFI but you\'d expect it only to be run within a branch for larger ones.  \n\nThere is probably is a limit of about 20/50k clients returned for html display (export to excel doesn\'t have that client browser/memory impact).', 1, 1),
	(5, 'Loans Awaiting Disbursal', 'Table', NULL, 'Loan', 'SELECT \r\nconcat(repeat("..",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\nc.account_no as "Client Account No", c.display_name as "Name", l.account_no as "Loan Account No.", pl.`name` as "Product", \r\nf.`name` as Fund, ifnull(cur.display_symbol, l.currency_code) as Currency,  \r\nl.principal_amount as Principal,  \r\nl.term_frequency as "Term Frequency",\n\n\r\ntf.enum_message_property as "Term Frequency Period",\r\nl.annual_nominal_interest_rate as " Annual Nominal Interest Rate",\r\ndate(l.approvedon_date) "Approved",\r\ndatediff(l.expected_disbursedon_date, curdate()) as "Days to Disbursal",\r\ndate(l.expected_disbursedon_date) "Expected Disbursal",\r\npurp.code_value as "Loan Purpose",\r\n lo.display_name as "Loan Officer"\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\r\nleft join r_enum_value tf on tf.enum_name = "term_period_frequency_enum" and tf.enum_id = l.term_period_frequency_enum\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 200\r\norder by ounder.hierarchy, datediff(l.expected_disbursedon_date, curdate()),  c.account_no', 'Individual Client Report', 1, 1),
	(6, 'Loans Awaiting Disbursal Summary', 'Table', NULL, 'Loan', 'SELECT \r\nconcat(repeat("..",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\npl.`name` as "Product", \r\nifnull(cur.display_symbol, l.currency_code) as Currency,  f.`name` as Fund,\r\nsum(l.principal_amount) as Principal\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 200\r\ngroup by ounder.hierarchy, pl.`name`, l.currency_code,  f.`name`\r\norder by ounder.hierarchy, pl.`name`, l.currency_code,  f.`name`', 'Individual Client Report', 1, 1),
	(7, 'Loans Awaiting Disbursal Summary by Month', 'Table', NULL, 'Loan', 'SELECT \r\nconcat(repeat("..",   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\npl.`name` as "Product", \r\nifnull(cur.display_symbol, l.currency_code) as Currency,  \r\nyear(l.expected_disbursedon_date) as "Year", \r\nmonthname(l.expected_disbursedon_date) as "Month",\r\nsum(l.principal_amount) as Principal\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 200\r\ngroup by ounder.hierarchy, pl.`name`, l.currency_code, year(l.expected_disbursedon_date), month(l.expected_disbursedon_date)\r\norder by ounder.hierarchy, pl.`name`, l.currency_code, year(l.expected_disbursedon_date), month(l.expected_disbursedon_date)', 'Individual Client Report', 1, 1),
	(8, 'Loans Pending Approval', 'Table', NULL, 'Loan', 'SELECT \r\nconcat(repeat("..",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\nc.account_no as "Client Account No.", c.display_name as "Client Name", \r\nifnull(cur.display_symbol, l.currency_code) as Currency,  pl.`name` as "Product", \r\nl.account_no as "Loan Account No.", \r\nl.principal_amount as "Loan Amount", \r\nl.term_frequency as "Term Frequency",\n\n\r\ntf.enum_message_property as "Term Frequency Period",\r\nl.annual_nominal_interest_rate as " Annual \n\nNominal Interest Rate", \r\ndatediff(curdate(), l.submittedon_date) "Days Pending Approval", \r\npurp.code_value as "Loan Purpose",\r\nlo.display_name as "Loan Officer"\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\r\nleft join r_enum_value tf on tf.enum_name = "term_period_frequency_enum" and tf.enum_id = l.term_period_frequency_enum\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 100 /*Submitted and awaiting approval */\r\norder by ounder.hierarchy, l.submittedon_date,  l.account_no', 'Individual Client Report', 1, 1),
	(11, 'Active Loans - Summary', 'Table', NULL, 'Loan', 'select concat(repeat("..",   \r\n   ((LENGTH(mo.`hierarchy`) - LENGTH(REPLACE(mo.`hierarchy`, \'.\', \'\')) - 1))), mo.`name`) as "Office/Branch", x.currency as Currency,\r\n x.client_count as "No. of Clients", x.active_loan_count as "No. Active Loans", x. loans_in_arrears_count as "No. of Loans in Arrears",\r\nx.principal as "Total Loans Disbursed", x.principal_repaid as "Principal Repaid", x.principal_outstanding as "Principal Outstanding", x.principal_overdue as "Principal Overdue",\r\nx.interest as "Total Interest", x.interest_repaid as "Interest Repaid", x.interest_outstanding as "Interest Outstanding", x.interest_overdue as "Interest Overdue",\r\nx.fees as "Total Fees", x.fees_repaid as "Fees Repaid", x.fees_outstanding as "Fees Outstanding", x.fees_overdue as "Fees Overdue",\r\nx.penalties as "Total Penalties", x.penalties_repaid as "Penalties Repaid", x.penalties_outstanding as "Penalties Outstanding", x.penalties_overdue as "Penalties Overdue",\r\n\r\n	(case\r\n	when ${parType} = 1 then\r\n    cast(round((x.principal_overdue * 100) / x.principal_outstanding, 2) as char)\r\n	when ${parType} = 2 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding), 2) as char)\r\n	when ${parType} = 3 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue + x.fees_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding + x.fees_outstanding), 2) as char)\r\n	when ${parType} = 4 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue + x.fees_overdue + x.penalties_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding + x.fees_outstanding + x.penalties_overdue), 2) as char)\r\n	else "invalid PAR Type"\r\n	end) as "Portfolio at Risk %"\r\n from m_office mo\r\njoin \r\n(select ounder.id as branch,\r\nifnull(cur.display_symbol, l.currency_code) as currency,\r\ncount(distinct(c.id)) as client_count, \r\ncount(distinct(l.id)) as  active_loan_count,\r\ncount(distinct(if(laa.loan_id is not null,  l.id, null)  )) as loans_in_arrears_count,\r\n\r\nsum(l.principal_disbursed_derived) as principal,\r\nsum(l.principal_repaid_derived) as principal_repaid,\r\nsum(l.principal_outstanding_derived) as principal_outstanding,\r\nsum(laa.principal_overdue_derived) as principal_overdue,\r\n\r\nsum(l.interest_charged_derived) as interest,\r\nsum(l.interest_repaid_derived) as interest_repaid,\r\nsum(l.interest_outstanding_derived) as interest_outstanding,\r\nsum(laa.interest_overdue_derived) as interest_overdue,\r\n\r\nsum(l.fee_charges_charged_derived) as fees,\r\nsum(l.fee_charges_repaid_derived) as fees_repaid,\r\nsum(l.fee_charges_outstanding_derived)  as fees_outstanding,\r\nsum(laa.fee_charges_overdue_derived) as fees_overdue,\r\n\r\nsum(l.penalty_charges_charged_derived) as penalties,\r\nsum(l.penalty_charges_repaid_derived) as penalties_repaid,\r\nsum(l.penalty_charges_outstanding_derived) as penalties_outstanding,\r\nsum(laa.penalty_charges_overdue_derived) as penalties_overdue\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\nleft join m_currency cur on cur.code = l.currency_code\r\n\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\ngroup by ounder.id, l.currency_code) x on x.branch = mo.id\r\norder by mo.hierarchy, x.Currency', NULL, 1, 1),
	(12, 'Active Loans - Details', 'Table', NULL, 'Loan', 'select concat(repeat("..",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\nlo.display_name as "Loan Officer", \r\nc.display_name as "Client", l.account_no as "Loan Account No.", pl.`name` as "Product", \r\nf.`name` as Fund,  \r\nl.principal_amount as "Loan Amount", \r\nl.annual_nominal_interest_rate as " Annual Nominal Interest Rate", \r\ndate(l.disbursedon_date) as "Disbursed Date", \r\ndate(l.expected_maturedon_date) as "Expected Matured On",\r\n\r\nl.principal_repaid_derived as "Principal Repaid",\r\nl.principal_outstanding_derived as "Principal Outstanding",\r\nlaa.principal_overdue_derived as "Principal Overdue",\r\n\r\nl.interest_repaid_derived as "Interest Repaid",\r\nl.interest_outstanding_derived as "Interest Outstanding",\r\nlaa.interest_overdue_derived as "Interest Overdue",\r\n\r\nl.fee_charges_repaid_derived as "Fees Repaid",\r\nl.fee_charges_outstanding_derived  as "Fees Outstanding",\r\nlaa.fee_charges_overdue_derived as "Fees Overdue",\r\n\r\nl.penalty_charges_repaid_derived as "Penalties Repaid",\r\nl.penalty_charges_outstanding_derived as "Penalties Outstanding",\r\npenalty_charges_overdue_derived as "Penalties Overdue"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\ngroup by l.id\r\norder by ounder.hierarchy, l.currency_code, c.account_no, l.account_no', 'Individual Client \n\nReport', 1, 1),
	(13, 'Obligation Met Loans Details', 'Table', NULL, 'Loan', 'select concat(repeat("..",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\nc.account_no as "Client Account No.", c.display_name as "Client",\r\nl.account_no as "Loan Account No.", pl.`name` as "Product", \r\nf.`name` as Fund,  \r\nl.principal_amount as "Loan Amount", \r\nl.total_repayment_derived  as "Total Repaid", \r\nl.annual_nominal_interest_rate as " Annual Nominal Interest Rate", \r\ndate(l.disbursedon_date) as "Disbursed", \r\ndate(l.closedon_date) as "Closed",\r\n\r\nl.principal_repaid_derived as "Principal Repaid",\r\nl.interest_repaid_derived as "Interest Repaid",\r\nl.fee_charges_repaid_derived as "Fees Repaid",\r\nl.penalty_charges_repaid_derived as "Penalties Repaid",\r\nlo.display_name as "Loan Officer"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand (case\r\n	when ${obligDateType} = 1 then\r\n    l.closedon_date between \'${startDate}\' and \'${endDate}\'\r\n	when ${obligDateType} = 2 then\r\n    l.disbursedon_date between \'${startDate}\' and \'${endDate}\'\r\n	else 1 = 1\r\n	end)\r\nand l.loan_status_id = 600\r\ngroup by l.id\r\norder by ounder.hierarchy, l.currency_code, c.account_no, l.account_no', 'Individual Client \n\nReport', 1, 1),
	(14, 'Obligation Met Loans Summary', 'Table', NULL, 'Loan', 'select concat(repeat("..",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\ncount(distinct(c.id)) as "No. of Clients",\r\ncount(distinct(l.id)) as "No. of Loans",\r\nsum(l.principal_amount) as "Total Loan Amount", \r\nsum(l.principal_repaid_derived) as "Total Principal Repaid",\r\nsum(l.interest_repaid_derived) as "Total Interest Repaid",\r\nsum(l.fee_charges_repaid_derived) as "Total Fees Repaid",\r\nsum(l.penalty_charges_repaid_derived) as "Total Penalties Repaid",\r\nsum(l.interest_waived_derived) as "Total Interest Waived",\r\nsum(l.fee_charges_waived_derived) as "Total Fees Waived",\r\nsum(l.penalty_charges_waived_derived) as "Total Penalties Waived"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand (case\r\n	when ${obligDateType} = 1 then\r\n    l.closedon_date between \'${startDate}\' and \'${endDate}\'\r\n	when ${obligDateType} = 2 then\r\n    l.disbursedon_date between \'${startDate}\' and \'${endDate}\'\r\n	else 1 = 1\r\n	end)\r\nand l.loan_status_id = 600\r\ngroup by ounder.hierarchy, l.currency_code\r\norder by ounder.hierarchy, l.currency_code', 'Individual Client \n\nReport', 1, 1),
	(15, 'Portfolio at Risk', 'Table', NULL, 'Loan', 'select x.Currency, x.`Principal Outstanding`, x.`Principal Overdue`, x.`Interest Outstanding`, x.`Interest Overdue`, \r\nx.`Fees Outstanding`, x.`Fees Overdue`, x.`Penalties Outstanding`, x.`Penalties Overdue`,\r\n\r\n	(case\r\n	when ${parType} = 1 then\r\n    cast(round((x.`Principal Overdue` * 100) / x.`Principal Outstanding`, 2) as char)\r\n	when ${parType} = 2 then\r\n    cast(round(((x.`Principal Overdue` + x.`Interest Overdue`) * 100) / (x.`Principal Outstanding` + x.`Interest Outstanding`), 2) as char)\r\n	when ${parType} = 3 then\r\n    cast(round(((x.`Principal Overdue` + x.`Interest Overdue` + x.`Fees Overdue`) * 100) / (x.`Principal Outstanding` + x.`Interest Outstanding` + x.`Fees Outstanding`), 2) as char)\r\n	when ${parType} = 4 then\r\n    cast(round(((x.`Principal Overdue` + x.`Interest Overdue` + x.`Fees Overdue` + x.`Penalties Overdue`) * 100) / (x.`Principal Outstanding` + x.`Interest Outstanding` + x.`Fees Outstanding` + x.`Penalties Overdue`), 2) as char)\r\n	else "invalid PAR Type"\r\n	end) as "Portfolio at Risk %"\r\n from \r\n(select  ifnull(cur.display_symbol, l.currency_code) as Currency,  \r\nsum(l.principal_outstanding_derived) as "Principal Outstanding",\r\nsum(laa.principal_overdue_derived) as "Principal Overdue",\r\n\r\nsum(l.interest_outstanding_derived) as "Interest Outstanding",\r\nsum(laa.interest_overdue_derived) as "Interest Overdue",\r\n\r\nsum(l.fee_charges_outstanding_derived)  as "Fees Outstanding",\r\nsum(laa.fee_charges_overdue_derived) as "Fees Overdue",\r\n\r\nsum(penalty_charges_outstanding_derived) as "Penalties Outstanding",\r\nsum(laa.penalty_charges_overdue_derived) as "Penalties Overdue"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin  m_loan l on l.client_id = c.id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\r\nleft join m_product_loan p on p.id = l.product_id\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\ngroup by l.currency_code\r\norder by l.currency_code) x', 'Covers all loans.\r\n\r\nFor larger MFIs … we should add some derived fields on loan (or a 1:1 loan related table like mifos 2.x does)\r\nPrinciple, Interest, Fees, Penalties Outstanding and Overdue (possibly waived and written off too)', 1, 1),
	(16, 'Portfolio at Risk by Branch', 'Table', NULL, 'Loan', 'select concat(repeat("..",   \r\n   ((LENGTH(mo.`hierarchy`) - LENGTH(REPLACE(mo.`hierarchy`, \'.\', \'\')) - 1))), mo.`name`) as "Office/Branch",\r\nx.Currency, x.`Principal Outstanding`, x.`Principal Overdue`, x.`Interest Outstanding`, x.`Interest Overdue`, \r\nx.`Fees Outstanding`, x.`Fees Overdue`, x.`Penalties Outstanding`, x.`Penalties Overdue`,\r\n\r\n	(case\r\n	when ${parType} = 1 then\r\n    cast(round((x.`Principal Overdue` * 100) / x.`Principal Outstanding`, 2) as char)\r\n	when ${parType} = 2 then\r\n    cast(round(((x.`Principal Overdue` + x.`Interest Overdue`) * 100) / (x.`Principal Outstanding` + x.`Interest Outstanding`), 2) as char)\r\n	when ${parType} = 3 then\r\n    cast(round(((x.`Principal Overdue` + x.`Interest Overdue` + x.`Fees Overdue`) * 100) / (x.`Principal Outstanding` + x.`Interest Outstanding` + x.`Fees Outstanding`), 2) as char)\r\n	when ${parType} = 4 then\r\n    cast(round(((x.`Principal Overdue` + x.`Interest Overdue` + x.`Fees Overdue` + x.`Penalties Overdue`) * 100) / (x.`Principal Outstanding` + x.`Interest Outstanding` + x.`Fees Outstanding` + x.`Penalties Overdue`), 2) as char)\r\n	else "invalid PAR Type"\r\n	end) as "Portfolio at Risk %"\r\n from m_office mo\r\njoin \r\n(select  ounder.id as "branch", ifnull(cur.display_symbol, l.currency_code) as Currency,  \r\n\r\nsum(l.principal_outstanding_derived) as "Principal Outstanding",\r\nsum(laa.principal_overdue_derived) as "Principal Overdue",\r\n\r\nsum(l.interest_outstanding_derived) as "Interest Outstanding",\r\nsum(laa.interest_overdue_derived) as "Interest Overdue",\r\n\r\nsum(l.fee_charges_outstanding_derived)  as "Fees Outstanding",\r\nsum(laa.fee_charges_overdue_derived) as "Fees Overdue",\r\n\r\nsum(penalty_charges_outstanding_derived) as "Penalties Outstanding",\r\nsum(laa.penalty_charges_overdue_derived) as "Penalties Overdue"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin  m_loan l on l.client_id = c.id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\r\nleft join m_product_loan p on p.id = l.product_id\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\ngroup by ounder.id, l.currency_code) x on x.branch = mo.id\r\norder by mo.hierarchy, x.Currency', 'Covers all loans.\r\n\r\nFor larger MFIs … we should add some derived fields on loan (or a 1:1 loan related table like mifos 2.x does)\r\nPrinciple, Interest, Fees, Penalties Outstanding and Overdue (possibly waived and written off too)', 1, 1),
	(20, 'Funds Disbursed Between Dates Summary', 'Table', NULL, 'Fund', 'select ifnull(f.`name`, \'-\') as Fund,  ifnull(cur.display_symbol, l.currency_code) as Currency, \r\nround(sum(l.principal_amount), 4) as disbursed_amount\r\nfrom m_office ounder \r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_currency cur on cur.`code` = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nwhere disbursedon_date between \'${startDate}\' and \'${endDate}\'\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (l.currency_code = \'${currencyId}\' or \'-1\' = \'${currencyId}\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\ngroup by ifnull(f.`name`, \'-\') , ifnull(cur.display_symbol, l.currency_code)\r\norder by ifnull(f.`name`, \'-\') , ifnull(cur.display_symbol, l.currency_code)', NULL, 1, 1),
	(21, 'Funds Disbursed Between Dates Summary by Office', 'Table', NULL, 'Fund', 'select \r\nconcat(repeat("..",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\n \n\nifnull(f.`name`, \'-\') as Fund,  ifnull(cur.display_symbol, l.currency_code) as Currency, round(sum(l.principal_amount), 4) as disbursed_amount\r\nfrom m_office o\r\n\n\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c \n\non c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_currency cur on cur.`code` = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\n\n\nwhere disbursedon_date between \'${startDate}\' and \'${endDate}\'\r\nand o.id = ${officeId}\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand \n\n(l.currency_code = \'${currencyId}\' or \'-1\' = \'${currencyId}\')\r\ngroup by ounder.`name`,  ifnull(f.`name`, \'-\') , ifnull(cur.display_symbol, \n\nl.currency_code)\r\norder by ounder.`name`,  ifnull(f.`name`, \'-\') , ifnull(cur.display_symbol, l.currency_code)', NULL, 1, 1),
	(48, 'Balance Sheet', 'Pentaho', NULL, 'Accounting', NULL, 'Balance Sheet', 1, 1),
	(49, 'Income Statement', 'Pentaho', NULL, 'Accounting', NULL, 'Profit and Loss Statement', 1, 1),
	(50, 'Trial Balance', 'Pentaho', NULL, 'Accounting', NULL, 'Trial Balance Report', 1, 1),
	(51, 'Written-Off Loans', 'Table', NULL, 'Loan', 'SELECT \r\nconcat(repeat("..",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\nifnull(cur.display_symbol, ml.currency_code) as Currency,  \r\nc.account_no as "Client Account No.",\r\nc.display_name AS \'Client Name\',\r\nml.account_no AS \'Loan Account No.\',\r\nmpl.name AS \'Product Name\',\r\nml.disbursedon_date AS \'Disbursed Date\',\r\nlt.transaction_date AS \'Written Off date\',\r\nml.principal_amount as "Loan Amount",\r\nifnull(lt.principal_portion_derived, 0) AS \'Written-Off Principal\',\r\nifnull(lt.interest_portion_derived, 0) AS \'Written-Off Interest\',\r\nifnull(lt.fee_charges_portion_derived,0) AS \'Written-Off Fees\',\r\nifnull(lt.penalty_charges_portion_derived,0) AS \'Written-Off Penalties\',\r\nn.note AS \'Reason For Write-Off\',\r\nIFNULL(ms.display_name,\'-\') AS \'Loan Officer Name\'\r\nFROM m_office o\r\nJOIN m_office ounder ON ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nAND ounder.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\nJOIN m_client c ON c.office_id = ounder.id\r\nJOIN m_loan ml ON ml.client_id = c.id\r\nJOIN m_product_loan mpl ON mpl.id=ml.product_id\r\nLEFT JOIN m_staff ms ON ms.id=ml.loan_officer_id\r\nJOIN m_loan_transaction lt ON lt.loan_id = ml.id\r\nLEFT JOIN m_note n ON n.loan_transaction_id = lt.id\r\nLEFT JOIN m_currency cur on cur.code = ml.currency_code\r\nWHERE lt.transaction_type_enum = 6 /*write-off */\r\nAND lt.is_reversed is false \r\nAND ml.loan_status_id=601\r\nAND o.id=${officeId}\r\nAND (mpl.id=${loanProductId} OR ${loanProductId}=-1)\r\nAND lt.transaction_date BETWEEN \'${startDate}\' AND \'${endDate}\'\r\nAND (ml.currency_code = "${currencyId}" or "-1" = "${currencyId}") \r\nORDER BY ounder.hierarchy, ifnull(cur.display_symbol, ml.currency_code), ml.account_no', 'Individual Lending Report. Written Off Loans', 1, 1),
	(52, 'Aging Detail', 'Table', NULL, 'Loan', '\r\nSELECT \r\nconcat(repeat("..",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\nifnull(cur.display_symbol, ml.currency_code) as Currency,  \r\nmc.account_no as "Client Account No.",\r\n 	mc.display_name AS "Client Name",\r\n 	ml.account_no AS "Account Number",\r\n 	ml.principal_amount AS "Loan Amount",\r\n ml.principal_disbursed_derived AS "Original Principal",\r\n ml.interest_charged_derived AS "Original Interest",\r\n ml.principal_repaid_derived AS "Principal Paid",\r\n ml.interest_repaid_derived AS "Interest Paid",\r\n laa.principal_overdue_derived AS "Principal Overdue",\r\n laa.interest_overdue_derived AS "Interest Overdue",\r\nDATEDIFF(CURDATE(), laa.overdue_since_date_derived) as "Days in Arrears",\r\n\r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<7, \'<1\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<8, \' 1\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<15,  \'2\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<22, \' 3\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<29, \' 4\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<36, \' 5\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<43, \' 6\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<50, \' 7\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<57, \' 8\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<64, \' 9\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<71, \'10\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<78, \'11\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<85, \'12\', \'12+\')))))))))))) )AS "Weeks In Arrears Band",\r\n\r\n		IF(DATEDIFF(CURDATE(),  laa.overdue_since_date_derived)<31, \'0 - 30\', \r\n		IF(DATEDIFF(CURDATE(),  laa.overdue_since_date_derived)<61, \'30 - 60\', \r\n		IF(DATEDIFF(CURDATE(),  laa.overdue_since_date_derived)<91, \'60 - 90\', \r\n		IF(DATEDIFF(CURDATE(),  laa.overdue_since_date_derived)<181, \'90 - 180\', \r\n		IF(DATEDIFF(CURDATE(),  laa.overdue_since_date_derived)<361, \'180 - 360\', \r\n				 \'> 360\'))))) AS "Days in Arrears Band"\r\n\r\n	FROM m_office mo \r\n    JOIN m_office ounder ON ounder.hierarchy like concat(mo.hierarchy, \'%\')\r\n	        AND ounder.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\n    INNER JOIN m_client mc ON mc.office_id=ounder.id\r\n	    INNER JOIN m_loan ml ON ml.client_id = mc.id\r\n	    INNER JOIN r_enum_value rev ON rev.enum_id=ml.loan_status_id AND rev.enum_name = \'loan_status_id\'\r\n    INNER JOIN m_loan_arrears_aging laa ON laa.loan_id=ml.id\r\n    left join m_currency cur on cur.code = ml.currency_code\r\n	WHERE ml.loan_status_id=300\r\n    AND mo.id=${officeId}\r\nORDER BY ounder.hierarchy, ifnull(cur.display_symbol, ml.currency_code), ml.account_no\r\n', 'Loan arrears aging (Weeks)', 1, 1),
	(53, 'Aging Summary (Arrears in Weeks)', 'Table', NULL, 'Loan', 'SELECT \r\n  IFNULL(periods.currencyName, periods.currency) as currency, \r\n  periods.period_no \'Weeks In Arrears (Up To)\', \r\n  IFNULL(ars.loanId, 0) \'No Of Loans\', \r\n  IFNULL(ars.principal,0.0) \'Original Principal\', \r\n  IFNULL(ars.interest,0.0) \'Original Interest\', \r\n  IFNULL(ars.prinPaid,0.0) \'Principal Paid\', \r\n  IFNULL(ars.intPaid,0.0) \'Interest Paid\', \r\n  IFNULL(ars.prinOverdue,0.0) \'Principal Overdue\', \r\n  IFNULL(ars.intOverdue,0.0)\'Interest Overdue\'\r\nFROM \r\n	/* full table of aging periods/currencies used combo to ensure each line represented */\r\n  (SELECT curs.code as currency, curs.name as currencyName, pers.* from\r\n	(SELECT \'On Schedule\' period_no,1 pid UNION\r\n		SELECT \'1\',2 UNION\r\n		SELECT \'2\',3 UNION\r\n		SELECT \'3\',4 UNION\r\n		SELECT \'4\',5 UNION\r\n		SELECT \'5\',6 UNION\r\n		SELECT \'6\',7 UNION\r\n		SELECT \'7\',8 UNION\r\n		SELECT \'8\',9 UNION\r\n		SELECT \'9\',10 UNION\r\n		SELECT \'10\',11 UNION\r\n		SELECT \'11\',12 UNION\r\n		SELECT \'12\',13 UNION\r\n		SELECT \'12+\',14) pers,\r\n	(SELECT distinctrow moc.code, moc.name\r\n  	FROM m_office mo2\r\n   	INNER JOIN m_office ounder2 ON ounder2.hierarchy \r\n				LIKE CONCAT(mo2.hierarchy, \'%\')\r\nAND ounder2.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\n   	INNER JOIN m_client mc2 ON mc2.office_id=ounder2.id\r\n   	INNER JOIN m_loan ml2 ON ml2.client_id = mc2.id\r\n	INNER JOIN m_organisation_currency moc ON moc.code = ml2.currency_code\r\n	WHERE ml2.loan_status_id=300 /* active */\r\n	AND mo2.id=${officeId}\r\nAND (ml2.currency_code = "${currencyId}" or "-1" = "${currencyId}")) curs) periods\r\n\r\n\r\nLEFT JOIN /* table of aging periods per currency with gaps if no applicable loans */\r\n(SELECT \r\n  	z.currency, z.arrPeriod, \r\n	COUNT(z.loanId) as loanId, SUM(z.principal) as principal, SUM(z.interest) as interest, \r\n	SUM(z.prinPaid) as prinPaid, SUM(z.intPaid) as intPaid, \r\n	SUM(z.prinOverdue) as prinOverdue, SUM(z.intOverdue) as intOverdue\r\nFROM\r\n	/*derived table just used to get arrPeriod value (was much slower to\r\n	duplicate calc of minOverdueDate in inner query)\r\nmight not be now with derived fields but didn’t check */\r\n	(SELECT x.loanId, x.currency, x.principal, x.interest, x.prinPaid, x.intPaid, x.prinOverdue, x.intOverdue,\r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<1, \'On Schedule\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<8, \'1\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<15, \'2\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<22, \'3\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<29, \'4\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<36, \'5\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<43, \'6\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<50, \'7\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<57, \'8\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<64, \'9\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<71, \'10\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<78, \'11\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<85, \'12\',\r\n				 \'12+\'))))))))))))) AS arrPeriod\r\n\r\n	FROM /* get the individual loan details */\r\n		(SELECT ml.id AS loanId, ml.currency_code as currency,\r\n   			ml.principal_disbursed_derived as principal, \r\n			   ml.interest_charged_derived as interest, \r\n   			ml.principal_repaid_derived as prinPaid, \r\n			   ml.interest_repaid_derived intPaid,\r\n\r\n			   laa.principal_overdue_derived as prinOverdue,\r\n			   laa.interest_overdue_derived as intOverdue,\r\n\r\n			   IFNULL(laa.overdue_since_date_derived, curdate()) as minOverdueDate\r\n			  \r\n  		FROM m_office mo\r\n   		INNER JOIN m_office ounder ON ounder.hierarchy \r\n				LIKE CONCAT(mo.hierarchy, \'%\')\r\nAND ounder.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\n   		INNER JOIN m_client mc ON mc.office_id=ounder.id\r\n   		INNER JOIN m_loan ml ON ml.client_id = mc.id\r\n		   LEFT JOIN m_loan_arrears_aging laa on laa.loan_id = ml.id\r\n		WHERE ml.loan_status_id=300 /* active */\r\n     		AND mo.id=${officeId}\r\n     AND (ml.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\n  		GROUP BY ml.id) x\r\n	) z \r\nGROUP BY z.currency, z.arrPeriod ) ars ON ars.arrPeriod=periods.period_no and ars.currency = periods.currency\r\nORDER BY periods.currency, periods.pid', 'Loan amount in arrears by branch', 1, 1),
	(54, 'Rescheduled Loans', 'Table', NULL, 'Loan', 'SELECT \r\nconcat(repeat("..",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\nifnull(cur.display_symbol, ml.currency_code) as Currency,  \r\nc.account_no as "Client Account No.",\r\nc.display_name AS \'Client Name\',\r\nml.account_no AS \'Loan Account No.\',\r\nmpl.name AS \'Product Name\',\r\nml.disbursedon_date AS \'Disbursed Date\',\r\nlt.transaction_date AS \'Written Off date\',\r\nml.principal_amount as "Loan Amount",\r\nifnull(lt.principal_portion_derived, 0) AS \'Rescheduled Principal\',\r\nifnull(lt.interest_portion_derived, 0) AS \'Rescheduled Interest\',\r\nifnull(lt.fee_charges_portion_derived,0) AS \'Rescheduled Fees\',\r\nifnull(lt.penalty_charges_portion_derived,0) AS \'Rescheduled Penalties\',\r\nn.note AS \'Reason For Rescheduling\',\r\nIFNULL(ms.display_name,\'-\') AS \'Loan Officer Name\'\r\nFROM m_office o\r\nJOIN m_office ounder ON ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nAND ounder.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\nJOIN m_client c ON c.office_id = ounder.id\r\nJOIN m_loan ml ON ml.client_id = c.id\r\nJOIN m_product_loan mpl ON mpl.id=ml.product_id\r\nLEFT JOIN m_staff ms ON ms.id=ml.loan_officer_id\r\nJOIN m_loan_transaction lt ON lt.loan_id = ml.id\r\nLEFT JOIN m_note n ON n.loan_transaction_id = lt.id\r\nLEFT JOIN m_currency cur on cur.code = ml.currency_code\r\nWHERE lt.transaction_type_enum = 7 /*marked for rescheduling */\r\nAND lt.is_reversed is false \r\nAND ml.loan_status_id=602\r\nAND o.id=${officeId}\r\nAND (mpl.id=${loanProductId} OR ${loanProductId}=-1)\r\nAND lt.transaction_date BETWEEN \'${startDate}\' AND \'${endDate}\'\r\nAND (ml.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nORDER BY ounder.hierarchy, ifnull(cur.display_symbol, ml.currency_code), ml.account_no', 'Individual Lending Report. Rescheduled Loans.  The ability to reschedule (or mark that you have rescheduled the loan elsewhere) is a legacy of the older Mifos product.  Needed for migration.', 1, 1),
	(55, 'Active Loans Passed Final Maturity', 'Table', NULL, 'Loan', 'select concat(repeat("..",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\nlo.display_name as "Loan Officer", \r\nc.display_name as "Client", l.account_no as "Loan Account No.", pl.`name` as "Product", \r\nf.`name` as Fund,  \r\nl.principal_amount as "Loan Amount", \r\nl.annual_nominal_interest_rate as " Annual Nominal Interest Rate", \r\ndate(l.disbursedon_date) as "Disbursed Date", \r\ndate(l.expected_maturedon_date) as "Expected Matured On",\r\n\r\nl.principal_repaid_derived as "Principal Repaid",\r\nl.principal_outstanding_derived as "Principal Outstanding",\r\nlaa.principal_overdue_derived as "Principal Overdue",\r\n\r\nl.interest_repaid_derived as "Interest Repaid",\r\nl.interest_outstanding_derived as "Interest Outstanding",\r\nlaa.interest_overdue_derived as "Interest Overdue",\r\n\r\nl.fee_charges_repaid_derived as "Fees Repaid",\r\nl.fee_charges_outstanding_derived  as "Fees Outstanding",\r\nlaa.fee_charges_overdue_derived as "Fees Overdue",\r\n\r\nl.penalty_charges_repaid_derived as "Penalties Repaid",\r\nl.penalty_charges_outstanding_derived as "Penalties Outstanding",\r\nlaa.penalty_charges_overdue_derived as "Penalties Overdue"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\nand l.expected_maturedon_date < curdate()\r\ngroup by l.id\r\norder by ounder.hierarchy, l.currency_code, c.account_no, l.account_no', 'Individual Client \n\nReport', 1, 1),
	(56, 'Active Loans Passed Final Maturity Summary', 'Table', NULL, 'Loan', 'select concat(repeat("..",   \r\n   ((LENGTH(mo.`hierarchy`) - LENGTH(REPLACE(mo.`hierarchy`, \'.\', \'\')) - 1))), mo.`name`) as "Office/Branch", x.currency as Currency,\r\n x.client_count as "No. of Clients", x.active_loan_count as "No. Active Loans", x. arrears_loan_count as "No. of Loans in Arrears",\r\nx.principal as "Total Loans Disbursed", x.principal_repaid as "Principal Repaid", x.principal_outstanding as "Principal Outstanding", x.principal_overdue as "Principal Overdue",\r\nx.interest as "Total Interest", x.interest_repaid as "Interest Repaid", x.interest_outstanding as "Interest Outstanding", x.interest_overdue as "Interest Overdue",\r\nx.fees as "Total Fees", x.fees_repaid as "Fees Repaid", x.fees_outstanding as "Fees Outstanding", x.fees_overdue as "Fees Overdue",\r\nx.penalties as "Total Penalties", x.penalties_repaid as "Penalties Repaid", x.penalties_outstanding as "Penalties Outstanding", x.penalties_overdue as "Penalties Overdue",\r\n\r\n	(case\r\n	when ${parType} = 1 then\r\n    cast(round((x.principal_overdue * 100) / x.principal_outstanding, 2) as char)\r\n	when ${parType} = 2 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding), 2) as char)\r\n	when ${parType} = 3 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue + x.fees_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding + x.fees_outstanding), 2) as char)\r\n	when ${parType} = 4 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue + x.fees_overdue + x.penalties_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding + x.fees_outstanding + x.penalties_overdue), 2) as char)\r\n	else "invalid PAR Type"\r\n	end) as "Portfolio at Risk %"\r\n from m_office mo\r\njoin \r\n(select ounder.id as branch,\r\nifnull(cur.display_symbol, l.currency_code) as currency,\r\ncount(distinct(c.id)) as client_count, \r\ncount(distinct(l.id)) as  active_loan_count,\r\ncount(distinct(laa.loan_id)  ) as arrears_loan_count,\r\n\r\nsum(l.principal_disbursed_derived) as principal,\r\nsum(l.principal_repaid_derived) as principal_repaid,\r\nsum(l.principal_outstanding_derived) as principal_outstanding,\r\nsum(ifnull(laa.principal_overdue_derived,0)) as principal_overdue,\r\n\r\nsum(l.interest_charged_derived) as interest,\r\nsum(l.interest_repaid_derived) as interest_repaid,\r\nsum(l.interest_outstanding_derived) as interest_outstanding,\r\nsum(ifnull(laa.interest_overdue_derived,0)) as interest_overdue,\r\n\r\nsum(l.fee_charges_charged_derived) as fees,\r\nsum(l.fee_charges_repaid_derived) as fees_repaid,\r\nsum(l.fee_charges_outstanding_derived)  as fees_outstanding,\r\nsum(ifnull(laa.fee_charges_overdue_derived,0)) as fees_overdue,\r\n\r\nsum(l.penalty_charges_charged_derived) as penalties,\r\nsum(l.penalty_charges_repaid_derived) as penalties_repaid,\r\nsum(l.penalty_charges_outstanding_derived) as penalties_outstanding,\r\nsum(ifnull(laa.penalty_charges_overdue_derived,0)) as penalties_overdue\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\n\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\nand l.expected_maturedon_date < curdate()\r\ngroup by ounder.id, l.currency_code) x on x.branch = mo.id\r\norder by mo.hierarchy, x.Currency', NULL, 1, 1),
	(57, 'Active Loans in last installment', 'Table', NULL, 'Loan', 'select concat(repeat("..",   \r\n   ((LENGTH(lastInstallment.`hierarchy`) - LENGTH(REPLACE(lastInstallment.`hierarchy`, \'.\', \'\')) - 1))), lastInstallment.branch) as "Office/Branch",\r\nlastInstallment.Currency,\r\nlastInstallment.`Loan Officer`, \r\nlastInstallment.`Client Account No`, lastInstallment.`Client`, \r\nlastInstallment.`Loan Account No`, lastInstallment.`Product`, \r\nlastInstallment.`Fund`,  lastInstallment.`Loan Amount`, \r\nlastInstallment.`Annual Nominal Interest Rate`, \r\nlastInstallment.`Disbursed`, lastInstallment.`Expected Matured On` ,\r\n\r\nl.principal_repaid_derived as "Principal Repaid",\r\nl.principal_outstanding_derived as "Principal Outstanding",\r\nlaa.principal_overdue_derived as "Principal Overdue",\r\n\r\nl.interest_repaid_derived as "Interest Repaid",\r\nl.interest_outstanding_derived as "Interest Outstanding",\r\nlaa.interest_overdue_derived as "Interest Overdue",\r\n\r\nl.fee_charges_repaid_derived as "Fees Repaid",\r\nl.fee_charges_outstanding_derived  as "Fees Outstanding",\r\nlaa.fee_charges_overdue_derived as "Fees Overdue",\r\n\r\nl.penalty_charges_repaid_derived as "Penalties Repaid",\r\nl.penalty_charges_outstanding_derived as "Penalties Outstanding",\r\nlaa.penalty_charges_overdue_derived as "Penalties Overdue"\r\n\r\nfrom \r\n(select l.id as loanId, l.number_of_repayments, min(r.installment), \r\nounder.id, ounder.hierarchy, ounder.`name` as branch, \r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\nlo.display_name as "Loan Officer", c.account_no as "Client Account No",\r\nc.display_name as "Client", l.account_no as "Loan Account No", pl.`name` as "Product", \r\nf.`name` as Fund,  l.principal_amount as "Loan Amount", \r\nl.annual_nominal_interest_rate as "Annual Nominal Interest Rate", \r\ndate(l.disbursedon_date) as "Disbursed", date(l.expected_maturedon_date) as "Expected Matured On"\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_loan_repayment_schedule r on r.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\nand r.completed_derived is false\r\nand r.duedate >= curdate()\r\ngroup by l.id\r\nhaving l.number_of_repayments = min(r.installment)) lastInstallment\r\njoin m_loan l on l.id = lastInstallment.loanId\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\norder by lastInstallment.hierarchy, lastInstallment.Currency, lastInstallment.`Client Account No`, lastInstallment.`Loan Account No`', 'Individual Client \n\nReport', 1, 1),
	(58, 'Active Loans in last installment Summary', 'Table', NULL, 'Loan', 'select concat(repeat("..",   \r\n   ((LENGTH(mo.`hierarchy`) - LENGTH(REPLACE(mo.`hierarchy`, \'.\', \'\')) - 1))), mo.`name`) as "Office/Branch", x.currency as Currency,\r\n x.client_count as "No. of Clients", x.active_loan_count as "No. Active Loans", x. arrears_loan_count as "No. of Loans in Arrears",\r\nx.principal as "Total Loans Disbursed", x.principal_repaid as "Principal Repaid", x.principal_outstanding as "Principal Outstanding", x.principal_overdue as "Principal Overdue",\r\nx.interest as "Total Interest", x.interest_repaid as "Interest Repaid", x.interest_outstanding as "Interest Outstanding", x.interest_overdue as "Interest Overdue",\r\nx.fees as "Total Fees", x.fees_repaid as "Fees Repaid", x.fees_outstanding as "Fees Outstanding", x.fees_overdue as "Fees Overdue",\r\nx.penalties as "Total Penalties", x.penalties_repaid as "Penalties Repaid", x.penalties_outstanding as "Penalties Outstanding", x.penalties_overdue as "Penalties Overdue",\r\n\r\n	(case\r\n	when ${parType} = 1 then\r\n    cast(round((x.principal_overdue * 100) / x.principal_outstanding, 2) as char)\r\n	when ${parType} = 2 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding), 2) as char)\r\n	when ${parType} = 3 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue + x.fees_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding + x.fees_outstanding), 2) as char)\r\n	when ${parType} = 4 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue + x.fees_overdue + x.penalties_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding + x.fees_outstanding + x.penalties_overdue), 2) as char)\r\n	else "invalid PAR Type"\r\n	end) as "Portfolio at Risk %"\r\n from m_office mo\r\njoin \r\n(select lastInstallment.branchId as branchId,\r\nlastInstallment.Currency,\r\ncount(distinct(lastInstallment.clientId)) as client_count, \r\ncount(distinct(lastInstallment.loanId)) as  active_loan_count,\r\ncount(distinct(laa.loan_id)  ) as arrears_loan_count,\r\n\r\nsum(l.principal_disbursed_derived) as principal,\r\nsum(l.principal_repaid_derived) as principal_repaid,\r\nsum(l.principal_outstanding_derived) as principal_outstanding,\r\nsum(ifnull(laa.principal_overdue_derived,0)) as principal_overdue,\r\n\r\nsum(l.interest_charged_derived) as interest,\r\nsum(l.interest_repaid_derived) as interest_repaid,\r\nsum(l.interest_outstanding_derived) as interest_outstanding,\r\nsum(ifnull(laa.interest_overdue_derived,0)) as interest_overdue,\r\n\r\nsum(l.fee_charges_charged_derived) as fees,\r\nsum(l.fee_charges_repaid_derived) as fees_repaid,\r\nsum(l.fee_charges_outstanding_derived)  as fees_outstanding,\r\nsum(ifnull(laa.fee_charges_overdue_derived,0)) as fees_overdue,\r\n\r\nsum(l.penalty_charges_charged_derived) as penalties,\r\nsum(l.penalty_charges_repaid_derived) as penalties_repaid,\r\nsum(l.penalty_charges_outstanding_derived) as penalties_outstanding,\r\nsum(ifnull(laa.penalty_charges_overdue_derived,0)) as penalties_overdue\r\n\r\nfrom \r\n(select l.id as loanId, l.number_of_repayments, min(r.installment), \r\nounder.id as branchId, ounder.hierarchy, ounder.`name` as branch, \r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\nlo.display_name as "Loan Officer", c.id as clientId, c.account_no as "Client Account No",\r\nc.display_name as "Client", l.account_no as "Loan Account No", pl.`name` as "Product", \r\nf.`name` as Fund,  l.principal_amount as "Loan Amount", \r\nl.annual_nominal_interest_rate as "Annual Nominal Interest Rate", \r\ndate(l.disbursedon_date) as "Disbursed", date(l.expected_maturedon_date) as "Expected Matured On"\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_loan_repayment_schedule r on r.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\nand r.completed_derived is false\r\nand r.duedate >= curdate()\r\ngroup by l.id\r\nhaving l.number_of_repayments = min(r.installment)) lastInstallment\r\njoin m_loan l on l.id = lastInstallment.loanId\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\ngroup by lastInstallment.branchId) x on x.branchId = mo.id\r\norder by mo.hierarchy, x.Currency', 'Individual Client \n\nReport', 1, 1),
	(59, 'Active Loans by Disbursal Period', 'Table', NULL, 'Loan', 'select concat(repeat("..",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as "Office/Branch",\r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\nc.account_no as "Client Account No", c.display_name as "Client", l.account_no as "Loan Account No", pl.`name` as "Product", \r\nf.`name` as Fund,  \r\nl.principal_amount as "Loan Principal Amount", \r\nl.annual_nominal_interest_rate as " Annual Nominal Interest Rate", \r\ndate(l.disbursedon_date) as "Disbursed Date", \r\n\r\nl.total_expected_repayment_derived as "Total Loan (P+I+F+Pen)",\r\nl.total_repayment_derived as "Total Repaid (P+I+F+Pen)",\r\nlo.display_name as "Loan Officer"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\nand (l.product_id = "${loanProductId}" or "-1" = "${loanProductId}")\r\nand (ifnull(l.loan_officer_id, -10) = "${loanOfficerId}" or "-1" = "${loanOfficerId}")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.disbursedon_date between \'${startDate}\' and \'${endDate}\'\r\nand l.loan_status_id = 300\r\ngroup by l.id\r\norder by ounder.hierarchy, l.currency_code, c.account_no, l.account_no', 'Individual Client \n\nReport', 1, 1),
	(61, 'Aging Summary (Arrears in Months)', 'Table', NULL, 'Loan', 'SELECT \r\n  IFNULL(periods.currencyName, periods.currency) as currency, \r\n  periods.period_no \'Days In Arrears\', \r\n  IFNULL(ars.loanId, 0) \'No Of Loans\', \r\n  IFNULL(ars.principal,0.0) \'Original Principal\', \r\n  IFNULL(ars.interest,0.0) \'Original Interest\', \r\n  IFNULL(ars.prinPaid,0.0) \'Principal Paid\', \r\n  IFNULL(ars.intPaid,0.0) \'Interest Paid\', \r\n  IFNULL(ars.prinOverdue,0.0) \'Principal Overdue\', \r\n  IFNULL(ars.intOverdue,0.0)\'Interest Overdue\'\r\nFROM \r\n	/* full table of aging periods/currencies used combo to ensure each line represented */\r\n  (SELECT curs.code as currency, curs.name as currencyName, pers.* from\r\n	(SELECT \'On Schedule\' period_no,1 pid UNION\r\n		SELECT \'0 - 30\',2 UNION\r\n		SELECT \'30 - 60\',3 UNION\r\n		SELECT \'60 - 90\',4 UNION\r\n		SELECT \'90 - 180\',5 UNION\r\n		SELECT \'180 - 360\',6 UNION\r\n		SELECT \'> 360\',7 ) pers,\r\n	(SELECT distinctrow moc.code, moc.name\r\n  	FROM m_office mo2\r\n   	INNER JOIN m_office ounder2 ON ounder2.hierarchy \r\n				LIKE CONCAT(mo2.hierarchy, \'%\')\r\nAND ounder2.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\n   	INNER JOIN m_client mc2 ON mc2.office_id=ounder2.id\r\n   	INNER JOIN m_loan ml2 ON ml2.client_id = mc2.id\r\n	INNER JOIN m_organisation_currency moc ON moc.code = ml2.currency_code\r\n	WHERE ml2.loan_status_id=300 /* active */\r\n	AND mo2.id=${officeId}\r\nAND (ml2.currency_code = "${currencyId}" or "-1" = "${currencyId}")) curs) periods\r\n\r\n\r\nLEFT JOIN /* table of aging periods per currency with gaps if no applicable loans */\r\n(SELECT \r\n  	z.currency, z.arrPeriod, \r\n	COUNT(z.loanId) as loanId, SUM(z.principal) as principal, SUM(z.interest) as interest, \r\n	SUM(z.prinPaid) as prinPaid, SUM(z.intPaid) as intPaid, \r\n	SUM(z.prinOverdue) as prinOverdue, SUM(z.intOverdue) as intOverdue\r\nFROM\r\n	/*derived table just used to get arrPeriod value (was much slower to\r\n	duplicate calc of minOverdueDate in inner query)\r\nmight not be now with derived fields but didn’t check */\r\n	(SELECT x.loanId, x.currency, x.principal, x.interest, x.prinPaid, x.intPaid, x.prinOverdue, x.intOverdue,\r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<1, \'On Schedule\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<31, \'0 - 30\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<61, \'30 - 60\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<91, \'60 - 90\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<181, \'90 - 180\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<361, \'180 - 360\', \r\n				 \'> 360\')))))) AS arrPeriod\r\n\r\n	FROM /* get the individual loan details */\r\n		(SELECT ml.id AS loanId, ml.currency_code as currency,\r\n   			ml.principal_disbursed_derived as principal, \r\n			   ml.interest_charged_derived as interest, \r\n   			ml.principal_repaid_derived as prinPaid, \r\n			   ml.interest_repaid_derived intPaid,\r\n\r\n			   laa.principal_overdue_derived as prinOverdue,\r\n			   laa.interest_overdue_derived as intOverdue,\r\n\r\n			   IFNULL(laa.overdue_since_date_derived, curdate()) as minOverdueDate\r\n			  \r\n  		FROM m_office mo\r\n   		INNER JOIN m_office ounder ON ounder.hierarchy \r\n				LIKE CONCAT(mo.hierarchy, \'%\')\r\nAND ounder.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\n   		INNER JOIN m_client mc ON mc.office_id=ounder.id\r\n   		INNER JOIN m_loan ml ON ml.client_id = mc.id\r\n		   LEFT JOIN m_loan_arrears_aging laa on laa.loan_id = ml.id\r\n		WHERE ml.loan_status_id=300 /* active */\r\n     		AND mo.id=${officeId}\r\n     AND (ml.currency_code = "${currencyId}" or "-1" = "${currencyId}")\r\n  		GROUP BY ml.id) x\r\n	) z \r\nGROUP BY z.currency, z.arrPeriod ) ars ON ars.arrPeriod=periods.period_no and ars.currency = periods.currency\r\nORDER BY periods.currency, periods.pid', 'Loan amount in arrears by branch', 1, 1),
	(91, 'Loan Account Schedule', 'Pentaho', NULL, 'Loan', NULL, NULL, 1, 0),
	(92, 'Branch Expected Cash Flow', 'Pentaho', NULL, 'Loan', NULL, NULL, 1, 1),
	(93, 'Expected Payments By Date - Basic', 'Table', NULL, 'Loan', 'SELECT \r\n      ounder.name \'Office\', \r\n      IFNULL(ms.display_name,\'-\') \'Loan Officer\',\r\n	  mc.account_no \'Client Account Number\',\r\n	  mc.display_name \'Name\',\r\n	  mp.name \'Product\',\r\n	  ml.account_no \'Loan Account Number\',\r\n	  mr.duedate \'Due Date\',\r\n	  mr.installment \'Installment\',\r\n	  cu.display_symbol \'Currency\',\r\n	  mr.principal_amount- IFNULL(mr.principal_completed_derived,0) \'Principal Due\',\r\n	  mr.interest_amount- IFNULL(IFNULL(mr.interest_completed_derived,mr.interest_waived_derived),0) \'Interest Due\', \r\n	  IFNULL(mr.fee_charges_amount,0)- IFNULL(IFNULL(mr.fee_charges_completed_derived,mr.fee_charges_waived_derived),0) \'Fees Due\', \r\n	  IFNULL(mr.penalty_charges_amount,0)- IFNULL(IFNULL(mr.penalty_charges_completed_derived,mr.penalty_charges_waived_derived),0) \'Penalty Due\',\r\n      (mr.principal_amount- IFNULL(mr.principal_completed_derived,0)) +\r\n       (mr.interest_amount- IFNULL(IFNULL(mr.interest_completed_derived,mr.interest_waived_derived),0)) + \r\n       (IFNULL(mr.fee_charges_amount,0)- IFNULL(IFNULL(mr.fee_charges_completed_derived,mr.fee_charges_waived_derived),0)) + \r\n       (IFNULL(mr.penalty_charges_amount,0)- IFNULL(IFNULL(mr.penalty_charges_completed_derived,mr.penalty_charges_waived_derived),0)) \'Total Due\', \r\n     mlaa.total_overdue_derived \'Total Overdue\'\r\n										 \r\n FROM m_office mo\r\n  JOIN m_office ounder ON ounder.hierarchy LIKE CONCAT(mo.hierarchy, \'%\')\r\n  \r\n  AND ounder.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\n	\r\n  LEFT JOIN m_client mc ON mc.office_id=ounder.id\r\n  LEFT JOIN m_loan ml ON ml.client_id=mc.id AND ml.loan_status_id=300\r\n  LEFT JOIN m_loan_arrears_aging mlaa ON mlaa.loan_id=ml.id\r\n  LEFT JOIN m_loan_repayment_schedule mr ON mr.loan_id=ml.id AND mr.completed_derived=0\r\n  LEFT JOIN m_product_loan mp ON mp.id=ml.product_id\r\n  LEFT JOIN m_staff ms ON ms.id=ml.loan_officer_id\r\n  LEFT JOIN m_currency cu ON cu.code=ml.currency_code\r\n WHERE mo.id=${officeId}\r\n AND (IFNULL(ml.loan_officer_id, -10) = "${loanOfficerId}" OR "-1" = "${loanOfficerId}")\r\n AND mr.duedate BETWEEN \'${startDate}\' AND \'${endDate}\'\r\n ORDER BY ounder.id,mr.duedate,ml.account_no', 'Test', 1, 1),
	(94, 'Expected Payments By Date - Formatted', 'Pentaho', NULL, 'Loan', NULL, NULL, 1, 1),
	(96, 'GroupSummaryCounts', 'Table', NULL, NULL, '\n/*\nActive Client is a client linked to the \'group\' via m_group_client \nand with an active \'status_enum\'.)\nActive Borrowers - Borrower may be a client or a \'group\'\n*/\nselect x.*\nfrom m_office o,\nm_group g,\n\n(select a.activeClients, \n(b.activeClientLoans + c.activeGroupLoans) as activeLoans, \nb.activeClientLoans, c.activeGroupLoans,\n(b.activeClientBorrowers + c.activeGroupBorrowers) as activeBorrowers,\nb.activeClientBorrowers, c.activeGroupBorrowers,\n(b.overdueClientLoans +  c.overdueGroupLoans) as overdueLoans,\nb.overdueClientLoans, c.overdueGroupLoans\nfrom\n(select count(*) as activeClients\nfrom m_group topgroup\njoin m_group g on g.hierarchy like concat(topgroup.hierarchy, \'%\')\njoin m_group_client gc on gc.group_id = g.id\njoin m_client c on c.id = gc.client_id\nwhere topgroup.id = ${groupId} \nand c.status_enum = 300) a,\n\n(select count(*) as activeClientLoans, \ncount(distinct(l.client_id)) as activeClientBorrowers,\nifnull(sum(if(laa.loan_id is not null, 1, 0)), 0) as overdueClientLoans\nfrom m_group topgroup\njoin m_group g on g.hierarchy like concat(topgroup.hierarchy, \'%\')\njoin m_loan l on l.group_id = g.id and l.client_id is not null\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\nwhere topgroup.id = ${groupId} \nand l.loan_status_id = 300) b,\n\n(select count(*) as activeGroupLoans, \ncount(distinct(l.group_id)) as activeGroupBorrowers,\nifnull(sum(if(laa.loan_id is not null, 1, 0)), 0) as overdueGroupLoans\nfrom m_group topgroup\njoin m_group g on g.hierarchy like concat(topgroup.hierarchy, \'%\')\njoin m_loan l on l.group_id = g.id and l.client_id is null\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\nwhere topgroup.id = ${groupId} \nand l.loan_status_id = 300) c\n) x\n\nwhere g.id = ${groupId}\nand o.id = g.office_id\nand o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\n', 'Utility query for getting group summary count details for a group_id', 1, 0),
	(97, 'GroupSummaryAmounts', 'Table', NULL, NULL, '\nselect ifnull(cur.display_symbol, l.currency_code) as currency,\nifnull(sum(l.principal_disbursed_derived),0) as totalDisbursedAmount,\nifnull(sum(l.principal_outstanding_derived),0) as totalLoanOutstandingAmount,\ncount(laa.loan_id) as overdueLoans, ifnull(sum(laa.total_overdue_derived), 0) as totalLoanOverdueAmount\nfrom m_group topgroup\njoin m_office o on o.id = topgroup.office_id and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_group g on g.hierarchy like concat(topgroup.hierarchy, \'%\')\njoin m_loan l on l.group_id = g.id\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\nleft join m_currency cur on cur.code = l.currency_code\nwhere topgroup.id = ${groupId}\nand l.disbursedon_date is not null\ngroup by l.currency_code\n', 'Utility query for getting group summary currency amount details for a group_id', 1, 0),
	(106, 'TxnRunningBalances', 'Table', NULL, 'Transaction', '\nselect date(\'${startDate}\') as \'Transaction Date\', \'Opening Balance\' as `Transaction Type`, null as Office,\n	null as \'Loan Officer\', null as `Loan Account No`, null as `Loan Product`, null as `Currency`, \n	null as `Client Account No`, null as Client, \n	null as Amount, null as Principal, null as Interest,\n@totalOutstandingPrincipal := 		  \nifnull(round(sum(\n	if (txn.transaction_type_enum = 1 /* disbursement */,\n		ifnull(txn.amount,0.00), \n		ifnull(txn.principal_portion_derived,0.00) * -1)) \n			,2),0.00)  as \'Outstanding Principal\',\n\n@totalInterestIncome := \nifnull(round(sum(\n	if (txn.transaction_type_enum in (2,5,8) /* repayment, repayment at disbursal, recovery repayment */,\n		ifnull(txn.interest_portion_derived,0.00), \n		0))\n			,2),0.00) as \'Interest Income\',\n\n@totalWriteOff :=\nifnull(round(sum(\n	if (txn.transaction_type_enum = 6 /* write-off */,\n		ifnull(txn.principal_portion_derived,0.00), \n		0)) \n			,2),0.00) as \'Principal Write Off\'\nfrom m_office o\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\n                          and ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_client c on c.office_id = ounder.id\njoin m_loan l on l.client_id = c.id\njoin m_product_loan lp on lp.id = l.product_id\njoin m_loan_transaction txn on txn.loan_id = l.id\nleft join m_currency cur on cur.code = l.currency_code\nwhere txn.is_reversed = false  \nand txn.transaction_type_enum not in (10,11)\nand o.id = ${officeId}\nand txn.transaction_date < date(\'${startDate}\')\n\nunion all\n\nselect x.`Transaction Date`, x.`Transaction Type`, x.Office, x.`Loan Officer`, x.`Loan Account No`, x.`Loan Product`, x.`Currency`, \n	x.`Client Account No`, x.Client, x.Amount, x.Principal, x.Interest,\ncast(round( \n	if (x.transaction_type_enum = 1 /* disbursement */,\n		@totalOutstandingPrincipal := @totalOutstandingPrincipal + x.`Amount`, \n		@totalOutstandingPrincipal := @totalOutstandingPrincipal - x.`Principal`) \n			,2) as decimal(19,2)) as \'Outstanding Principal\',\ncast(round(\n	if (x.transaction_type_enum in (2,5,8) /* repayment, repayment at disbursal, recovery repayment */,\n		@totalInterestIncome := @totalInterestIncome + x.`Interest`, \n		@totalInterestIncome) \n			,2) as decimal(19,2)) as \'Interest Income\',\ncast(round(\n	if (x.transaction_type_enum = 6 /* write-off */,\n		@totalWriteOff := @totalWriteOff + x.`Principal`, \n		@totalWriteOff) \n			,2) as decimal(19,2)) as \'Principal Write Off\'\nfrom\n(select txn.transaction_type_enum, txn.id as txn_id, txn.transaction_date as \'Transaction Date\', \ncast(\n	ifnull(re.enum_message_property, concat(\'Unknown Transaction Type Value: \' , txn.transaction_type_enum)) \n	as char) as \'Transaction Type\',\nounder.`name` as Office, lo.display_name as \'Loan Officer\',\nl.account_no  as \'Loan Account No\', lp.`name` as \'Loan Product\', \nifnull(cur.display_symbol, l.currency_code) as Currency,\nc.account_no as \'Client Account No\', c.display_name as \'Client\',\nifnull(txn.amount,0.00) as Amount,\nifnull(txn.principal_portion_derived,0.00) as Principal,\nifnull(txn.interest_portion_derived,0.00) as Interest\nfrom m_office o\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\n                          and ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_client c on c.office_id = ounder.id\njoin m_loan l on l.client_id = c.id\nleft join m_staff lo on lo.id = l.loan_officer_id\njoin m_product_loan lp on lp.id = l.product_id\njoin m_loan_transaction txn on txn.loan_id = l.id\nleft join m_currency cur on cur.code = l.currency_code\nleft join r_enum_value re on re.enum_name = \'transaction_type_enum\'\n						and re.enum_id = txn.transaction_type_enum\nwhere txn.is_reversed = false  \nand txn.transaction_type_enum not in (10,11)\nand (ifnull(l.loan_officer_id, -10) = \'${loanOfficerId}\' or \'-1\' = \'${loanOfficerId}\')\nand o.id = ${officeId}\nand txn.transaction_date >= date(\'${startDate}\')\nand txn.transaction_date <= date(\'${endDate}\')\norder by txn.transaction_date, txn.id) x\n', 'Running Balance Txn report for Individual Lending.\nSuitable for small MFI\'s.  Larger could use it using the branch or other parameters.\nBasically, suck it and see if its quick enough for you out-of-te box or whether it needs performance work in your situation.\n', 0, 0),
	(107, 'FieldAgentStats', 'Table', NULL, 'Quipo', '\nselect ifnull(cur.display_symbol, l.currency_code) as Currency,\n/*This query will return more than one entry if more than one currency is used */\ncount(distinct(c.id)) as activeClients, count(*) as activeLoans,\nsum(l.principal_disbursed_derived) as disbursedAmount,\nsum(l.principal_outstanding_derived) as loanOutstandingAmount,\nround((sum(l.principal_outstanding_derived) * 100) /  sum(l.principal_disbursed_derived),2) as loanOutstandingPC,\nsum(ifnull(lpa.principal_in_advance_derived,0.0)) as LoanPaidInAdvance,\nsum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) as portfolioAtRisk,\n\nround((sum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) * 100) / sum(l.principal_outstanding_derived), 2) as portfolioAtRiskPC,\n\ncount(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) as clientsInDefault,\nround((count(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) * 100) / count(distinct(c.id)),2) as clientsInDefaultPC,\n(sum(l.principal_disbursed_derived) / count(*))  as averageLoanAmount\nfrom m_staff fa\njoin m_office o on o.id = fa.office_id\n			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_group pgm on pgm.staff_id = fa.id\njoin m_loan l on l.group_id = pgm.id and l.client_id is not null\nleft join m_currency cur on cur.code = l.currency_code\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id \nleft join m_loan_paid_in_advance lpa on lpa.loan_id = l.id \njoin m_client c on c.id = l.client_id\nwhere fa.id = ${staffId}\nand l.loan_status_id = 300\ngroup  by l.currency_code\n', 'Field Agent Statistics', 0, 0),
	(108, 'FieldAgentPrograms', 'Table', NULL, 'Quipo', ' \nselect pgm.id, pgm.display_name as `name`, sts.enum_message_property as status\n from m_group pgm \n join m_office o on o.id = pgm.office_id\n 			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\n left join r_enum_value sts on sts.enum_name = \'status_enum\' and sts.enum_id = pgm.status_enum\n where pgm.staff_id = ${staffId} \n', 'List of Field Agent Programs', 0, 0),
	(109, 'ProgramDetails', 'Table', NULL, 'Quipo', '\n select l.id as loanId, l.account_no as loanAccountNo, c.id as clientId, c.account_no as clientAccountNo,\n pgm.display_name as programName, \n\n(select count(*)\nfrom m_loan cy\nwhere cy.group_id = pgm.id and cy.client_id =c.id\nand cy.disbursedon_date <= l.disbursedon_date) as loanCycleNo,\n\nc.display_name as clientDisplayName,\n ifnull(cur.display_symbol, l.currency_code) as Currency,\nifnull(l.principal_repaid_derived,0.0) as loanRepaidAmount,\nifnull(l.principal_outstanding_derived, 0.0) as loanOutstandingAmount,\nifnull(lpa.principal_in_advance_derived,0.0) as LoanPaidInAdvance,\n\nifnull(laa.principal_overdue_derived, 0.0) as loanInArrearsAmount, \nif(ifnull(laa.principal_overdue_derived, 0.00) > 0, \'Yes\', \'No\') as inDefault,\n\nif(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)  as portfolioAtRisk\n\n from m_group pgm\n join m_office o on o.id = pgm.office_id\n 			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\n join m_loan l on l.group_id = pgm.id and l.client_id is not null\n left join m_currency cur on cur.code = l.currency_code\n join m_client c on c.id = l.client_id\n left join m_loan_arrears_aging laa on laa.loan_id = l.id\n left join m_loan_paid_in_advance lpa on lpa.loan_id = l.id \n where pgm.id = ${programId}\n and l.loan_status_id = 300\norder by c.display_name, l.account_no\n \n', 'List of Loans in a Program', 0, 0),
	(110, 'ChildrenStaffList', 'Table', NULL, 'Quipo', '\n select s.id, s.display_name, \ns.firstname, s.lastname, s.organisational_role_enum, \ns.organisational_role_parent_staff_id, \nsp.display_name as `organisational_role_parent_staff_display_name` \nfrom m_staff s \njoin m_staff sp on s.organisational_role_parent_staff_id = sp.id \nwhere s.organisational_role_parent_staff_id = ${staffId}\n', 'Get Next Level Down Staff', 0, 0),
	(111, 'CoordinatorStats', 'Table', NULL, 'Quipo', '\nselect ifnull(cur.display_symbol, l.currency_code) as Currency,\n/*This query will return more than one entry if more than one currency is used */\ncount(distinct(c.id)) as activeClients, count(*) as activeLoans,\nsum(l.principal_disbursed_derived) as disbursedAmount,\nsum(l.principal_outstanding_derived) as loanOutstandingAmount,\nround((sum(l.principal_outstanding_derived) * 100) /  sum(l.principal_disbursed_derived),2) as loanOutstandingPC,\nsum(ifnull(lpa.principal_in_advance_derived,0.0)) as LoanPaidInAdvance,\nsum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) as portfolioAtRisk,\n\nround((sum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) * 100) / sum(l.principal_outstanding_derived), 2) as portfolioAtRiskPC,\n\ncount(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) as clientsInDefault,\nround((count(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) * 100) / count(distinct(c.id)),2) as clientsInDefaultPC,\n(sum(l.principal_disbursed_derived) / count(*))  as averageLoanAmount\nfrom m_staff coord\njoin m_staff fa on fa.organisational_role_parent_staff_id = coord.id\njoin m_office o on o.id = fa.office_id\n			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_group pgm on pgm.staff_id = fa.id\njoin m_loan l on l.group_id = pgm.id and l.client_id is not null\nleft join m_currency cur on cur.code = l.currency_code\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id \nleft join m_loan_paid_in_advance lpa on lpa.loan_id = l.id \njoin m_client c on c.id = l.client_id\nwhere coord.id = ${staffId}\nand l.loan_status_id = 300\ngroup  by l.currency_code\n', 'Coordinator Statistics', 0, 0),
	(112, 'BranchManagerStats', 'Table', NULL, 'Quipo', '\nselect ifnull(cur.display_symbol, l.currency_code) as Currency,\n/*This query will return more than one entry if more than one currency is used */\ncount(distinct(c.id)) as activeClients, count(*) as activeLoans,\nsum(l.principal_disbursed_derived) as disbursedAmount,\nsum(l.principal_outstanding_derived) as loanOutstandingAmount,\nround((sum(l.principal_outstanding_derived) * 100) /  sum(l.principal_disbursed_derived),2) as loanOutstandingPC,\nsum(ifnull(lpa.principal_in_advance_derived,0.0)) as LoanPaidInAdvance,\nsum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) as portfolioAtRisk,\n\nround((sum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) * 100) / sum(l.principal_outstanding_derived), 2) as portfolioAtRiskPC,\n\ncount(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) as clientsInDefault,\nround((count(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) * 100) / count(distinct(c.id)),2) as clientsInDefaultPC,\n(sum(l.principal_disbursed_derived) / count(*))  as averageLoanAmount\nfrom m_staff bm\njoin m_staff coord on coord.organisational_role_parent_staff_id = bm.id\njoin m_staff fa on fa.organisational_role_parent_staff_id = coord.id\njoin m_office o on o.id = fa.office_id\n			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_group pgm on pgm.staff_id = fa.id\njoin m_loan l on l.group_id = pgm.id and l.client_id is not null\nleft join m_currency cur on cur.code = l.currency_code\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id \nleft join m_loan_paid_in_advance lpa on lpa.loan_id = l.id \njoin m_client c on c.id = l.client_id\nwhere bm.id = ${staffId}\nand l.loan_status_id = 300\ngroup  by l.currency_code\n', 'Branch Manager Statistics', 0, 0),
	(113, 'ProgramDirectorStats', 'Table', NULL, 'Quipo', '\nselect ifnull(cur.display_symbol, l.currency_code) as Currency,\n/*This query will return more than one entry if more than one currency is used */\ncount(distinct(c.id)) as activeClients, count(*) as activeLoans,\nsum(l.principal_disbursed_derived) as disbursedAmount,\nsum(l.principal_outstanding_derived) as loanOutstandingAmount,\nround((sum(l.principal_outstanding_derived) * 100) /  sum(l.principal_disbursed_derived),2) as loanOutstandingPC,\nsum(ifnull(lpa.principal_in_advance_derived,0.0)) as LoanPaidInAdvance,\nsum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) as portfolioAtRisk,\n\nround((sum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) * 100) / sum(l.principal_outstanding_derived), 2) as portfolioAtRiskPC,\n\ncount(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) as clientsInDefault,\nround((count(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) * 100) / count(distinct(c.id)),2) as clientsInDefaultPC,\n(sum(l.principal_disbursed_derived) / count(*))  as averageLoanAmount\nfrom m_staff pd\njoin m_staff bm on bm.organisational_role_parent_staff_id = pd.id\njoin m_staff coord on coord.organisational_role_parent_staff_id = bm.id\njoin m_staff fa on fa.organisational_role_parent_staff_id = coord.id\njoin m_office o on o.id = fa.office_id\n			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_group pgm on pgm.staff_id = fa.id\njoin m_loan l on l.group_id = pgm.id and l.client_id is not null\nleft join m_currency cur on cur.code = l.currency_code\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id \nleft join m_loan_paid_in_advance lpa on lpa.loan_id = l.id \njoin m_client c on c.id = l.client_id\nwhere pd.id = ${staffId}\nand l.loan_status_id = 300\ngroup  by l.currency_code\n', 'Program DirectorStatistics', 0, 0),
	(114, 'ProgramStats', 'Table', NULL, 'Quipo', '\nselect ifnull(cur.display_symbol, l.currency_code) as Currency,\n/*This query will return more than one entry if more than one currency is used */\ncount(distinct(c.id)) as activeClients, count(*) as activeLoans,\nsum(l.principal_disbursed_derived) as disbursedAmount,\nsum(l.principal_outstanding_derived) as loanOutstandingAmount,\nround((sum(l.principal_outstanding_derived) * 100) /  sum(l.principal_disbursed_derived),2) as loanOutstandingPC,\nsum(ifnull(lpa.principal_in_advance_derived,0.0)) as LoanPaidInAdvance,\nsum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) as portfolioAtRisk,\n\nround((sum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) * 100) / sum(l.principal_outstanding_derived), 2) as portfolioAtRiskPC,\n\ncount(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) as clientsInDefault,\nround((count(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) * 100) / count(distinct(c.id)),2) as clientsInDefaultPC,\n(sum(l.principal_disbursed_derived) / count(*))  as averageLoanAmount\nfrom m_group pgm\njoin m_office o on o.id = pgm.office_id\n			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_loan l on l.group_id = pgm.id and l.client_id is not null\nleft join m_currency cur on cur.code = l.currency_code\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id \nleft join m_loan_paid_in_advance lpa on lpa.loan_id = l.id \njoin m_client c on c.id = l.client_id\nwhere pgm.id = ${programId}\nand l.loan_status_id = 300\ngroup  by l.currency_code\n', 'Program Statistics', 0, 0),
	(115, 'ClientSummary ', 'Table', NULL, NULL, 'SELECT x.* FROM m_client c, m_office o, \n(\n       SELECT a.loanCycle, a.activeLoans, b.lastLoanAmount, d.activeSavings, d.totalSavings FROM \n	(SELECT IFNULL(MAX(l.loan_counter),0) AS loanCycle, COUNT(l.id) AS activeLoans FROM m_loan l WHERE l.loan_status_id=300 AND l.client_id=${clientId}) a, \n	(SELECT count(l.id), IFNULL(l.principal_amount,0) AS \'lastLoanAmount\' FROM m_loan l WHERE l.client_id=${clientId} AND l.disbursedon_date = (SELECT IFNULL(MAX(disbursedon_date),NOW()) FROM m_loan where client_id=${clientId} and loan_status_id=300)) b, \n	(SELECT COUNT(s.id) AS \'activeSavings\', IFNULL(SUM(s.account_balance_derived),0) AS \'totalSavings\' FROM m_savings_account s WHERE s.status_enum=300 AND s.client_id=${clientId}) d\n) x\nWHERE c.id=${clientId} AND o.id = c.office_id AND o.hierarchy LIKE CONCAT(\'${currentUserHierarchy}\', \'%\')', 'Utility query for getting the client summary details', 1, 0),
	(116, 'LoanCyclePerProduct', 'Table', NULL, NULL, 'SELECT lp.name AS \'productName\', MAX(l.loan_product_counter) AS \'loanProductCycle\' FROM m_loan l JOIN m_product_loan lp ON l.product_id=lp.id WHERE lp.include_in_borrower_cycle=1 AND l.loan_product_counter IS NOT NULL AND l.client_id=${clientId} GROUP BY l.product_id', 'Utility query for getting the client loan cycle details', 1, 0),
	(117, 'GroupSavingSummary', 'Table', NULL, NULL, 'select ifnull(cur.display_symbol, sa.currency_code) as currency,\ncount(sa.id) as totalSavingAccounts, ifnull(sum(sa.account_balance_derived),0) as totalSavings\nfrom m_group topgroup\njoin m_office o on o.id = topgroup.office_id and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_group g on g.hierarchy like concat(topgroup.hierarchy, \'%\')\njoin m_savings_account sa on sa.group_id = g.id\nleft join m_currency cur on cur.code = sa.currency_code\nwhere topgroup.id = ${groupId}\nand sa.activatedon_date is not null\ngroup by sa.currency_code', 'Utility query for getting group or center saving summary details for a group_id', 1, 0),
	(118, 'Savings Transactions', 'Pentaho', NULL, 'Savings', NULL, NULL, 0, 1),
	(119, 'Client Savings Summary', 'Pentaho', NULL, 'Savings', NULL, NULL, 0, 1),
	(120, 'Active Loans - Details(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(121, 'Active Loans - Summary(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(122, 'Active Loans by Disbursal Period(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(123, 'Active Loans in last installment Summary(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(124, 'Active Loans in last installment(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(125, 'Active Loans Passed Final Maturity Summary(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(126, 'Active Loans Passed Final Maturity(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(127, 'Aging Detail(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(128, 'Aging Summary (Arrears in Months)(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(129, 'Aging Summary (Arrears in Weeks)(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(130, 'Client Listing(Pentaho)', 'Pentaho', NULL, 'Client', '(NULL)', '(NULL)', 1, 1),
	(131, 'Client Loans Listing(Pentaho)', 'Pentaho', NULL, 'Client', '(NULL)', '(NULL)', 1, 1),
	(132, 'Expected Payments By Date - Basic(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(133, 'Funds Disbursed Between Dates Summary by Office(Pentaho)', 'Pentaho', NULL, 'Fund', '(NULL)', '(NULL)', 1, 1),
	(134, 'Funds Disbursed Between Dates Summary(Pentaho)', 'Pentaho', NULL, 'Fund', '(NULL)', '(NULL)', 1, 1),
	(135, 'Loans Awaiting Disbursal Summary by Month(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(136, 'Loans Awaiting Disbursal Summary(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(137, 'Loans Awaiting Disbursal(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(138, 'Loans Pending Approval(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(139, 'Obligation Met Loans Details(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(140, 'Obligation Met Loans Summary(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(141, 'Portfolio at Risk by Branch(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(142, 'Portfolio at Risk(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(143, 'Rescheduled Loans(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(144, 'TxnRunningBalances(Pentaho)', 'Pentaho', NULL, 'Transaction', '(NULL)', '(NULL)', 1, 1),
	(145, 'Written-Off Loans(Pentaho)', 'Pentaho', NULL, 'Loan', '(NULL)', '(NULL)', 1, 1),
	(146, 'Client Saving Transactions', 'Pentaho', NULL, 'Savings', NULL, NULL, 0, 0),
	(147, 'Client Loan Account Schedule', 'Pentaho', NULL, 'Loans', NULL, NULL, 0, 0),
	(148, 'GroupNamesByStaff', 'Table', '', '', 'Select gr.id as id, gr.display_name as name from m_group gr where gr.level_id=1 and gr.staff_id = ${staffId}', '', 0, 1),
	(149, 'ClientTrendsByDay', 'Table', '', 'Client', 'SELECT 	COUNT(cl.id) AS count, \n		cl.activation_date AS days\nFROM m_office of \n	LEFT JOIN m_client cl on of.id = cl.office_id\nWHERE of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),"%" ) \n	AND (cl.activation_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 DAY) AND DATE(NOW()- INTERVAL 1 DAY))\nGROUP BY days', 'Retrieves the number of clients joined in last 12 days', 0, 1),
	(150, 'ClientTrendsByWeek', 'Table', '', 'Client', 'SELECT 	COUNT(cl.id) AS count, \n		WEEK(cl.activation_date) AS Weeks\nFROM m_office of \n	LEFT JOIN m_client cl on of.id = cl.office_id\nWHERE of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),"%" ) \n	AND (cl.activation_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 WEEK) AND DATE(NOW()))\nGROUP BY Weeks', '', 0, 1),
	(151, 'ClientTrendsByMonth', 'Table', '', 'Client', 'SELECT 	COUNT(cl.id) AS count, \n		MONTHNAME(cl.activation_date) AS Months\nFROM m_office of \n	LEFT JOIN m_client cl on of.id = cl.office_id\nWHERE of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),"%" ) \n	AND (cl.activation_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 MONTH) AND DATE(NOW()))\nGROUP BY Months', '', 0, 1),
	(152, 'LoanTrendsByDay', 'Table', '', 'Loan', 'SELECT 	COUNT(ln.id) AS lcount, \n		ln.disbursedon_date AS days\nFROM m_office of \n	LEFT JOIN m_client cl on of.id = cl.office_id\n	LEFT JOIN m_loan ln on cl.id = ln.client_id\nWHERE of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),"%" ) \n	AND (ln.disbursedon_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 DAY) AND DATE(NOW()- INTERVAL 1 DAY))\nGROUP BY days', 'Retrieves Number of loans disbursed for last 12 days', 0, 1),
	(153, 'LoanTrendsByWeek', 'Table', '', 'Loan', 'SELECT 	COUNT(ln.id) AS lcount, \n		WEEK(ln.disbursedon_date) AS Weeks\nFROM m_office of \n	LEFT JOIN m_client cl on of.id = cl.office_id\n	LEFT JOIN m_loan ln on cl.id = ln.client_id\nWHERE of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),"%" ) \n	AND (ln.disbursedon_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 WEEK) AND DATE(NOW()))\nGROUP BY Weeks', '', 0, 1),
	(154, 'LoanTrendsByMonth', 'Table', '', 'Loan', 'SELECT 	COUNT(ln.id) AS lcount, \n		MONTHNAME(ln.disbursedon_date) AS Months\nFROM m_office of \n	LEFT JOIN m_client cl on of.id = cl.office_id\n	LEFT JOIN m_loan ln on cl.id = ln.client_id\nWHERE of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),"%" ) \n	AND (ln.disbursedon_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 MONTH) AND DATE(NOW()))\nGROUP BY Months', '', 0, 1),
	(155, 'Demand_Vs_Collection', 'Table', '', 'Loan', 'select amount.AmountDue-amount.AmountPaid as AmountDue, amount.AmountPaid as AmountPaid from\n(SELECT \n(IFNULL(SUM(ls.principal_amount),0) - IFNULL(SUM(ls.principal_writtenoff_derived),0)\n + IFNULL(SUM(ls.interest_amount),0) - IFNULL(SUM(ls.interest_writtenoff_derived),0) \n - IFNULL(SUM(ls.interest_waived_derived),0)\n + IFNULL(SUM(ls.fee_charges_amount),0) - IFNULL(SUM(ls.fee_charges_writtenoff_derived),0) \n - IFNULL(SUM(ls.fee_charges_waived_derived),0)\n + IFNULL(SUM(ls.penalty_charges_amount),0) - IFNULL(SUM(ls.penalty_charges_writtenoff_derived),0) \n - IFNULL(SUM(ls.penalty_charges_waived_derived),0)\n) AS AmountDue, \n\n(IFNULL(SUM(ls.principal_completed_derived),0) - IFNULL(SUM(ls.principal_writtenoff_derived),0) + IFNULL(SUM(ls.interest_completed_derived),0) - IFNULL(SUM(ls.interest_writtenoff_derived),0) \n - IFNULL(SUM(ls.interest_waived_derived),0)\n + IFNULL(SUM(ls.fee_charges_completed_derived),0) - IFNULL(SUM(ls.fee_charges_writtenoff_derived),0) \n - IFNULL(SUM(ls.fee_charges_waived_derived),0)\n + IFNULL(SUM(ls.penalty_charges_completed_derived),0) - IFNULL(SUM(ls.penalty_charges_writtenoff_derived),0) \n - IFNULL(SUM(ls.penalty_charges_waived_derived),0)\n) AS AmountPaid\nFROM m_office of\nLEFT JOIN m_client cl ON of.id = cl.office_id\nLEFT JOIN m_loan ln ON cl.id = ln.client_id\nLEFT JOIN m_loan_repayment_schedule ls ON ln.id = ls.loan_id\nWHERE ls.duedate = DATE(NOW()) AND \n (of.hierarchy LIKE CONCAT((\nSELECT ino.hierarchy\nFROM m_office ino\nWHERE ino.id = ${officeId}),"%"))) as amount', 'Demand Vs Collection', 0, 1),
	(156, 'Disbursal_Vs_Awaitingdisbursal', 'Table', '', 'Loan', 'select awaitinddisbursal.amount-disbursedAmount.amount as amountToBeDisburse, disbursedAmount.amount as disbursedAmount from \n(\nSELECT 	COUNT(ln.id) AS noOfLoans, \n			IFNULL(SUM(ln.principal_amount),0) AS amount\nFROM \nm_office of\nLEFT JOIN m_client cl ON cl.office_id = of.id\nLEFT JOIN m_loan ln ON cl.id = ln.client_id\nWHERE \nln.expected_disbursedon_date = DATE(NOW()) AND \n(ln.loan_status_id=200 OR ln.loan_status_id=300) AND\n of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),"%" )\n) awaitinddisbursal,\n(\nSELECT 	COUNT(ltrxn.id) as count, \n			IFNULL(SUM(ltrxn.amount),0) as amount \nFROM \nm_office of\nLEFT JOIN m_client cl ON cl.office_id = of.id\nLEFT JOIN m_loan ln ON cl.id = ln.client_id\nLEFT JOIN m_loan_transaction ltrxn ON ln.id = ltrxn.loan_id\nWHERE \nltrxn.transaction_date = DATE(NOW()) AND \nltrxn.transaction_type_enum=1 AND\n of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),"%" ) \n) disbursedAmount', 'Disbursal_Vs_Awaitingdisbursal', 0, 1);
/*!40000 ALTER TABLE `stretchy_report` ENABLE KEYS */;


-- stretchy_report_parameter
CREATE TABLE IF NOT EXISTS `stretchy_report_parameter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) NOT NULL,
  `parameter_id` int(11) NOT NULL,
  `report_parameter_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `report_parameter_unique` (`report_id`,`parameter_id`),
  KEY `fk_report_parameter_001_idx` (`report_id`),
  KEY `fk_report_parameter_002_idx` (`parameter_id`),
  CONSTRAINT `fk_report_parameter_001` FOREIGN KEY (`report_id`) REFERENCES `stretchy_report` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_report_parameter_002` FOREIGN KEY (`parameter_id`) REFERENCES `stretchy_parameter` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=426 DEFAULT CHARSET=utf8;

-- stretchy_report_parameter: ~319 rows (approximately)
/*!40000 ALTER TABLE `stretchy_report_parameter` DISABLE KEYS */;
INSERT INTO `stretchy_report_parameter` (`id`, `report_id`, `parameter_id`, `report_parameter_name`) VALUES
	(1, 1, 5, NULL),
	(2, 2, 5, NULL),
	(3, 2, 6, NULL),
	(4, 2, 10, NULL),
	(5, 2, 20, NULL),
	(6, 2, 25, NULL),
	(7, 2, 26, NULL),
	(8, 5, 5, NULL),
	(9, 5, 6, NULL),
	(10, 5, 10, NULL),
	(11, 5, 20, NULL),
	(12, 5, 25, NULL),
	(13, 5, 26, NULL),
	(14, 6, 5, NULL),
	(15, 6, 6, NULL),
	(16, 6, 10, NULL),
	(17, 6, 20, NULL),
	(18, 6, 25, NULL),
	(19, 6, 26, NULL),
	(20, 7, 5, NULL),
	(21, 7, 6, NULL),
	(22, 7, 10, NULL),
	(23, 7, 20, NULL),
	(24, 7, 25, NULL),
	(25, 7, 26, NULL),
	(26, 8, 5, NULL),
	(27, 8, 6, NULL),
	(28, 8, 10, NULL),
	(29, 8, 25, NULL),
	(30, 8, 26, NULL),
	(31, 11, 5, NULL),
	(32, 11, 6, NULL),
	(33, 11, 10, NULL),
	(34, 11, 20, NULL),
	(35, 11, 25, NULL),
	(36, 11, 26, NULL),
	(37, 11, 100, NULL),
	(38, 12, 5, NULL),
	(39, 12, 6, NULL),
	(40, 12, 10, NULL),
	(41, 12, 20, NULL),
	(42, 12, 25, NULL),
	(43, 12, 26, NULL),
	(44, 13, 1, NULL),
	(45, 13, 2, NULL),
	(46, 13, 3, NULL),
	(47, 13, 5, NULL),
	(48, 13, 6, NULL),
	(49, 13, 10, NULL),
	(50, 13, 20, NULL),
	(51, 13, 25, NULL),
	(52, 13, 26, NULL),
	(53, 14, 1, NULL),
	(54, 14, 2, NULL),
	(55, 14, 3, NULL),
	(56, 14, 5, NULL),
	(57, 14, 6, NULL),
	(58, 14, 10, NULL),
	(59, 14, 20, NULL),
	(60, 14, 25, NULL),
	(61, 14, 26, NULL),
	(62, 15, 5, NULL),
	(63, 15, 6, NULL),
	(64, 15, 10, NULL),
	(65, 15, 20, NULL),
	(66, 15, 25, NULL),
	(67, 15, 26, NULL),
	(68, 15, 100, NULL),
	(69, 16, 5, NULL),
	(70, 16, 6, NULL),
	(71, 16, 10, NULL),
	(72, 16, 20, NULL),
	(73, 16, 25, NULL),
	(74, 16, 26, NULL),
	(75, 16, 100, NULL),
	(76, 20, 1, NULL),
	(77, 20, 2, NULL),
	(78, 20, 10, NULL),
	(79, 20, 20, NULL),
	(80, 21, 1, NULL),
	(81, 21, 2, NULL),
	(82, 21, 5, NULL),
	(83, 21, 10, NULL),
	(84, 21, 20, NULL),
	(85, 48, 5, 'branch'),
	(86, 48, 2, 'date'),
	(87, 49, 5, 'branch'),
	(88, 49, 1, 'fromDate'),
	(89, 49, 2, 'toDate'),
	(90, 50, 5, 'branch'),
	(91, 50, 1, 'fromDate'),
	(92, 50, 2, 'toDate'),
	(93, 51, 1, NULL),
	(94, 51, 2, NULL),
	(95, 51, 5, NULL),
	(96, 51, 10, NULL),
	(97, 51, 25, NULL),
	(98, 52, 5, NULL),
	(99, 53, 5, NULL),
	(100, 53, 10, NULL),
	(101, 54, 1, NULL),
	(102, 54, 2, NULL),
	(103, 54, 5, NULL),
	(104, 54, 10, NULL),
	(105, 54, 25, NULL),
	(106, 55, 5, NULL),
	(107, 55, 6, NULL),
	(108, 55, 10, NULL),
	(109, 55, 20, NULL),
	(110, 55, 25, NULL),
	(111, 55, 26, NULL),
	(112, 56, 5, NULL),
	(113, 56, 6, NULL),
	(114, 56, 10, NULL),
	(115, 56, 20, NULL),
	(116, 56, 25, NULL),
	(117, 56, 26, NULL),
	(118, 56, 100, NULL),
	(119, 57, 5, NULL),
	(120, 57, 6, NULL),
	(121, 57, 10, NULL),
	(122, 57, 20, NULL),
	(123, 57, 25, NULL),
	(124, 57, 26, NULL),
	(125, 58, 5, NULL),
	(126, 58, 6, NULL),
	(127, 58, 10, NULL),
	(128, 58, 20, NULL),
	(129, 58, 25, NULL),
	(130, 58, 26, NULL),
	(131, 58, 100, NULL),
	(132, 59, 1, NULL),
	(133, 59, 2, NULL),
	(134, 59, 5, NULL),
	(135, 59, 6, NULL),
	(136, 59, 10, NULL),
	(137, 59, 20, NULL),
	(138, 59, 25, NULL),
	(139, 59, 26, NULL),
	(140, 61, 5, NULL),
	(141, 61, 10, NULL),
	(142, 92, 1, 'fromDate'),
	(143, 92, 5, 'selectOffice'),
	(144, 92, 2, 'toDate'),
	(145, 93, 1, NULL),
	(146, 93, 2, NULL),
	(147, 93, 5, NULL),
	(148, 93, 6, NULL),
	(149, 94, 2, 'endDate'),
	(150, 94, 6, 'loanOfficerId'),
	(151, 94, 5, 'officeId'),
	(152, 94, 1, 'startDate'),
	(256, 106, 2, NULL),
	(257, 106, 6, NULL),
	(258, 106, 5, NULL),
	(259, 106, 1, NULL),
	(263, 118, 1, 'fromDate'),
	(264, 118, 2, 'toDate'),
	(265, 118, 1004, 'accountNo'),
	(266, 119, 1, 'fromDate'),
	(267, 119, 2, 'toDate'),
	(268, 119, 5, 'selectOffice'),
	(269, 119, 1005, 'selectProduct'),
	(270, 120, 5, 'branch'),
	(271, 120, 6, 'loanOfficer'),
	(272, 120, 10, 'currencyId'),
	(273, 120, 20, 'fundId'),
	(274, 120, 25, 'loanProductId'),
	(275, 120, 26, 'loanPurposeId'),
	(276, 121, 5, 'Branch'),
	(277, 121, 6, 'loanOfficer'),
	(278, 121, 10, 'CurrencyId'),
	(279, 121, 20, 'fundId'),
	(280, 121, 25, 'loanProductId'),
	(281, 121, 26, 'loanPurposeId'),
	(282, 121, 100, 'parType'),
	(283, 122, 5, 'Branch'),
	(284, 122, 6, 'loanOfficer'),
	(285, 122, 10, 'CurrencyId'),
	(286, 122, 20, 'fundId'),
	(287, 122, 25, 'loanProductId'),
	(288, 122, 26, 'loanPurposeId'),
	(289, 122, 1, 'startDate'),
	(290, 122, 2, 'endDate'),
	(291, 123, 5, 'Branch'),
	(292, 123, 6, 'Loan Officer'),
	(293, 123, 10, 'CurrencyId'),
	(294, 123, 20, 'fundId'),
	(295, 123, 25, 'loanProductId'),
	(296, 123, 26, 'loanPurposeId'),
	(297, 123, 100, 'parType'),
	(298, 124, 5, 'Branch'),
	(299, 124, 6, 'Loan Officer'),
	(300, 124, 10, 'CurrencyId'),
	(301, 124, 20, 'fundId'),
	(302, 124, 25, 'loanProductId'),
	(303, 124, 26, 'loanPurposeId'),
	(304, 125, 5, 'Branch'),
	(305, 125, 6, 'Loan Officer'),
	(306, 125, 10, 'CurrencyId'),
	(307, 125, 20, 'fundId'),
	(308, 125, 25, 'loanProductId'),
	(309, 125, 26, 'loanPurposeId'),
	(310, 125, 100, 'parType'),
	(311, 126, 5, 'Branch'),
	(312, 126, 6, 'Loan Officer'),
	(313, 126, 10, 'CurrencyId'),
	(314, 126, 20, 'fundId'),
	(315, 126, 25, 'loanProductId'),
	(316, 126, 26, 'loanPurposeId'),
	(317, 127, 5, 'Branch'),
	(318, 128, 5, 'Branch'),
	(319, 128, 10, 'CurrencyId'),
	(320, 129, 5, 'Branch'),
	(321, 129, 10, 'CurrencyId'),
	(322, 130, 5, 'selectOffice'),
	(323, 131, 5, 'Branch'),
	(324, 131, 6, 'Loan Officer'),
	(325, 131, 10, 'CurrencyId'),
	(326, 131, 20, 'fundId'),
	(327, 131, 25, 'loanProductId'),
	(328, 131, 26, 'loanPurposeId'),
	(329, 132, 5, 'Branch'),
	(330, 132, 6, 'Loan Officer'),
	(331, 132, 1, 'startDate'),
	(332, 132, 2, 'endDate'),
	(333, 133, 5, 'Branch'),
	(334, 133, 10, 'CurrencyId'),
	(335, 133, 20, 'fundId'),
	(336, 133, 1, 'startDate'),
	(337, 133, 2, 'endDate'),
	(338, 134, 10, 'CurrencyId'),
	(339, 134, 20, 'fundId'),
	(340, 134, 1, 'startDate'),
	(341, 134, 2, 'endDate'),
	(342, 135, 5, 'Branch'),
	(343, 135, 6, 'Loan Officer'),
	(344, 135, 10, 'CurrencyId'),
	(345, 135, 20, 'fundId'),
	(346, 135, 25, 'loanProductId'),
	(347, 135, 26, 'loanPurposeId'),
	(348, 136, 5, 'Branch'),
	(349, 136, 6, 'Loan Officer'),
	(350, 136, 10, 'CurrencyId'),
	(351, 136, 20, 'fundId'),
	(352, 136, 25, 'loanProductId'),
	(353, 136, 26, 'loanPurposeId'),
	(354, 137, 5, 'Branch'),
	(355, 137, 6, 'Loan Officer'),
	(356, 137, 10, 'CurrencyId'),
	(357, 137, 20, 'fundId'),
	(358, 137, 25, 'loanProductId'),
	(359, 137, 26, 'loanPurposeId'),
	(360, 138, 5, 'Branch'),
	(361, 138, 6, 'Loan Officer'),
	(362, 138, 10, 'CurrencyId'),
	(363, 138, 20, 'fundId'),
	(364, 138, 25, 'loanProductId'),
	(365, 138, 26, 'loanPurposeId'),
	(366, 139, 5, 'Branch'),
	(367, 139, 6, 'Loan Officer'),
	(368, 139, 10, 'CurrencyId'),
	(369, 139, 20, 'fundId'),
	(370, 139, 25, 'loanProductId'),
	(371, 139, 26, 'loanPurposeId'),
	(372, 139, 1, 'startDate'),
	(373, 139, 2, 'endDate'),
	(374, 139, 3, 'obligDateType'),
	(375, 140, 5, 'Branch'),
	(376, 140, 6, 'Loan Officer'),
	(377, 140, 10, 'CurrencyId'),
	(378, 140, 20, 'fundId'),
	(379, 140, 25, 'loanProductId'),
	(380, 140, 26, 'loanPurposeId'),
	(381, 140, 1, 'Startdate'),
	(382, 140, 2, 'Enddate'),
	(383, 140, 3, 'obligDateType'),
	(384, 141, 5, 'Branch'),
	(385, 141, 6, 'Loan Officer'),
	(386, 141, 10, 'CurrencyId'),
	(387, 141, 20, 'fundId'),
	(388, 141, 25, 'loanProductId'),
	(389, 141, 26, 'loanPurposeId'),
	(390, 141, 100, 'parType'),
	(391, 142, 5, 'Branch'),
	(392, 142, 6, 'loanOfficer'),
	(393, 142, 10, 'CurrencyId'),
	(394, 142, 20, 'fundId'),
	(395, 142, 25, 'loanProductId'),
	(396, 142, 26, 'loanPurposeId'),
	(397, 142, 100, 'parType'),
	(398, 143, 5, 'Branch'),
	(399, 143, 10, 'CurrencyId'),
	(400, 143, 25, 'loanProductId'),
	(401, 143, 1, 'startDate'),
	(402, 143, 2, 'endDate'),
	(403, 144, 5, 'Branch'),
	(404, 144, 6, 'Loan Officer'),
	(405, 144, 1, 'startDate'),
	(406, 144, 2, 'endDate'),
	(407, 145, 5, 'Branch'),
	(408, 145, 10, 'CurrencyId'),
	(409, 145, 25, 'loanProductId'),
	(410, 145, 1, 'startDate'),
	(411, 145, 2, 'endDate'),
	(412, 146, 1, 'startDate'),
	(413, 146, 2, 'endDate'),
	(414, 146, 1004, 'accountNo'),
	(415, 147, 1, 'startDate'),
	(416, 147, 2, 'endDate'),
	(417, 147, 1004, 'accountNo'),
	(418, 149, 5, ''),
	(419, 150, 5, ''),
	(420, 151, 5, ''),
	(421, 152, 5, ''),
	(422, 153, 5, ''),
	(423, 154, 5, ''),
	(424, 155, 5, ''),
	(425, 156, 5, '');
/*!40000 ALTER TABLE `stretchy_report_parameter` ENABLE KEYS */;


-- x_registered_table
CREATE TABLE IF NOT EXISTS `x_registered_table` (
  `registered_table_name` varchar(50) NOT NULL,
  `application_table_name` varchar(50) NOT NULL,
  PRIMARY KEY (`registered_table_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- x_registered_table: ~0 rows (approximately)
/*!40000 ALTER TABLE `x_registered_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `x_registered_table` ENABLE KEYS */;


-- x_table_column_code_mappings
CREATE TABLE IF NOT EXISTS `x_table_column_code_mappings` (
  `column_alias_name` varchar(50) NOT NULL,
  `code_id` int(10) NOT NULL,
  PRIMARY KEY (`column_alias_name`),
  KEY `FK_x_code_id` (`code_id`),
  CONSTRAINT `FK_x_code_id` FOREIGN KEY (`code_id`) REFERENCES `m_code` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- x_table_column_code_mappings: ~0 rows (approximately)
/*!40000 ALTER TABLE `x_table_column_code_mappings` DISABLE KEYS */;
/*!40000 ALTER TABLE `x_table_column_code_mappings` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
