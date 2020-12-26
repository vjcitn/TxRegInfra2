library(TxRegInfra2)

context("test local") # local service is used
test_that("listAllCollections succeeds", {
if (verifyHasMongoCmd()) {
  c1 <- listAllCollections(url=URL_txregLocal(), db="txregnet")
  expect_true(length(c1)>=5)
  }
})

context("test collection names as anticipated")
test_that("collection names are as anticipated", {
if (verifyHasMongoCmd()) {
  known_25dec2020 = c("ENCFF001WBZ_hg19_HS", "fLung_DS14724_hg19_FP", "fPlacenta_DS20346_hg19_FP", 
"Lung_allpairs_v7_eQTL", "M5946_1_02_tf")
  c1 <- listAllCollections(url=URL_txregLocal(), db="txregnet")
  expect_true(all(known_25dec2020 %in% c1))
  expect_true(all(rownames(basicColData.tiny) %in% c1))
  }
})

