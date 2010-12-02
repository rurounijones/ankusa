require File.join File.dirname(__FILE__), 'helper'

module ClassifierBase
  def setup
    @storage.init_tables
    @ankusa = Ankusa::Classifier.new @storage
    @ankusa.train :spam, "spam and great spam"   # spam:2 great:1
    @ankusa.train :good, "words for processing" # word:1 process:1
    @ankusa.train :good, "good word"            # word:1 good:1      
  end

  def test_train
    counts = @storage.get_word_counts(:spam)
    assert_equal counts[:spam], 2
    counts = @storage.get_word_counts(:word)
    assert_equal counts[:good], 2 
    assert_equal @storage.get_total_word_count(:good), 4
    assert_equal @storage.get_doc_count(:good), 2
    assert_equal @storage.get_total_word_count(:spam), 3
    assert_equal @storage.get_doc_count(:spam), 1
    assert_equal @storage.doc_count_total, 3
  end

  def test_probs
    spamlog = Math.log(3.0/4.0) + Math.log(1.0 / 4.0) + Math.log(1.0 / 3.0)
    goodlog = Math.log(1.0 / 5.0) + Math.log(1.0 / 5.0) + Math.log(2.0 / 3.0)

    cs = @ankusa.classifications("spam is tastey")
    assert_equal cs[:spam], spamlog
    assert_equal cs[:good], goodlog
  end

  def test_prob_result
    cs = @ankusa.classifications("spam is tastey").sort_by { |c| c[1] }.first.first
    assert_equal cs, @ankusa.classify("spam is tastey")
  end
  
  def teardown
    @storage.drop_tables
    @storage.close
  end
end
