


##### Models #################################################################

models/enwiki.attack.gradient_boosting.model: \
		datasets/detox_labels.mturk.dev_train.w_cache.json.bz2
	bzcat datasets/detox_labels.mturk.dev_train.w_cache.json.bz2 | \
	revscoring cv_test \
		revscoring.scorer_models.GradientBoosting \
		editquality.feature_lists.enwiki.goodfaith \
		attack \
		--version=0.0.1 \
		-p 'max_depth=7' \
		-p 'learning_rate=0.01' \
		-p 'max_features="log2"' \
		-p 'n_estimators=700' \
		$(test_statistics) \
		--balance-sample-weight \
		--center --scale > \
	models/enwiki.attack.gradient_boosting.model

models/enwiki.aggression.gradient_boosting.model: \
		datasets/detox_labels.mturk.dev_train.w_cache.json.bz2
	bzcat datasets/detox_labels.mturk.dev_train.w_cache.json.bz2 | \
	revscoring cv_test \
		revscoring.scorer_models.GradientBoosting \
		editquality.feature_lists.enwiki.goodfaith \
		aggression \
		--version=0.0.1 \
		-p 'max_depth=7' \
		-p 'learning_rate=0.01' \
		-p 'max_features="log2"' \
		-p 'n_estimators=700' \
		$(test_statistics) \
		--balance-sample-weight \
		--center --scale > \
	models/enwiki.attack.gradient_boosting.model


###### Feature sets ###########################################################
datasets/detox_labels.mturk.dev_train.w_cache.json.bz2: \
		datasets/detox_labels.mturk.dev.json.bz2 \
		datasets/detox_labels.mturk.train.json.bz2
	bzcat \
		datasets/detox_labels.mturk.dev.json.bz2 \
		datasets/detox_labels.mturk.train.json.bz2 | \
	revscoring extract --host https://en.wikipedia.org \
		editquality.feature_lists.enwiki.goodfaith \
		--verbose | bzip2 -c > \
	datasets/detox_labels.mturk.dev_train.w_cache.json.bz2

###### Datasets ###############################################################

base_datasets: \
	datasets/detox_annotations.mturk.dev.json.bz2 \
	datasets/detox_annotations.mturk.train.json.bz2 \
	datasets/detox_annotations.mturk.test.json.bz2

label_datasets: \
	datasets/detox_labels.mturk.dev.json.bz2 \
	datasets/detox_labels.mturk.train.json.bz2 \
	datasets/detox_labels.mturk.test.json.bz2 \

datasets/detox_annotations.mturk.dev.json.bz2: \
		datasets/dirty_tsv/detox_annotations.mturk.dev.dirty_tsv.bz2
	bzcat datasets/dirty_tsv/detox_annotations.mturk.dev.dirty_tsv.bz2 | \
	python clean_detox_tsv.py | \
	bzip2 -c > datasets/detox_annotations.mturk.dev.json.bz2

datasets/detox_annotations.mturk.train.json.bz2: \
		datasets/dirty_tsv/detox_annotations.mturk.train.dirty_tsv.bz2
	bzcat datasets/dirty_tsv/detox_annotations.mturk.train.dirty_tsv.bz2 | \
	python clean_detox_tsv.py | \
	bzip2 -c > datasets/detox_annotations.mturk.train.json.bz2

datasets/detox_annotations.mturk.test.json.bz2: \
		datasets/dirty_tsv/detox_annotations.mturk.test.dirty_tsv.bz2
	bzcat datasets/dirty_tsv/detox_annotations.mturk.test.dirty_tsv.bz2 | \
	python clean_detox_tsv.py | \
	bzip2 -c > datasets/detox_annotations.mturk.test.json.bz2

datasets/detox_labels.mturk.dev.json.bz2: \
		datasets/detox_annotations.mturk.dev.json.bz2
	bzcat datasets/detox_annotations.mturk.dev.json.bz2 | \
	python aggregate_annotations.py | \
	bzip2 -c > datasets/detox_labels.mturk.dev.json.bz2

datasets/detox_labels.mturk.train.json.bz2: \
		datasets/detox_annotations.mturk.train.json.bz2
	bzcat datasets/detox_annotations.mturk.train.json.bz2 | \
	python aggregate_annotations.py | \
	bzip2 -c > datasets/detox_labels.mturk.train.json.bz2

datasets/detox_labels.mturk.test.json.bz2: \
		datasets/detox_annotations.mturk.test.json.bz2
	bzcat datasets/detox_annotations.mturk.test.json.bz2 | \
	python aggregate_annotations.py | \
	bzip2 -c > datasets/detox_labels.mturk.test.json.bz2
