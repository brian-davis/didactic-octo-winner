# frozen_string_literal:true

# Working from book Impractical Python Projects, Lee Vaughan, No Starch Press
#   https://nostarch.com/impracticalpythonprojects
# Porting exercizes to Ruby. Chapter 8 uses Python NLTK library,
# a tool for interacting with Carnegie Mellon University Pronouncing Dictionary
#   https://github.com/rhdunn/cmudict-tools
#   http://www.speech.cs.cmu.edu/cgi-bin/cmudict
#
# Running Python >>> `nltk.download('cmudict')`
# downloads the data file to $ ~/nltk_data/corpora/cmudict/cmudict

module NLTK
  # Like Python's `from nltk.corpus import cmudict`
  #   https://www.nltk.org/
  #   https://www.nltk.org/api/nltk.corpus.reader.cmudict.html
  module CMUDict
    module Config
      DATAFILE_DEFAULT_PATH = "~/nltk_data/corpora/cmudict/cmudict"

      class << self
        def filepath
          @filepath ||= File.expand_path(DATAFILE_DEFAULT_PATH)
        end

        # pass nil to reset
        def filepath=(str)
          @filepath = str
        end
      end # class << self
    end # module Config

    class << self
      # All lines from the data file.
      # =>
      # [
      # ...
      # "ABDICATION 1 AE2 B D IH0 K EY1 SH AH0 N",
      # ...
      # "ZYUGANOV'S 1 Z Y UW1 G AA0 N AA0 V Z",
      # "ZYUGANOV'S 2 Z UW1 G AA0 N AA0 V Z",
      # ...
      # ]
      private def data
        @data ||= File.readlines(Config.filepath).map(&:chomp)
      end

      # Like `cmudict.dict()`
      # Parse data file, return a Hash object which maps words (string, key) to syllable lists (array of arrays of strings, value)
      #
      # =>
      # {
      # ...
      # "abdication" => [["AE2", "B", "D", "IH0", "K", "EY1", "SH", "AH0", "N"]]
      # ...
      # "zyuganov's" => [["Z", "Y", "UW1", "G", "AA0", "N", "AA0", "V", "Z"], ["Z", "UW1", "G", "AA0", "N", "AA0", "V", "Z"]]
      # }
      def dict
        @dict ||= begin
          data.each.with_object({}) do |line, memo|
            word, instance, *syllables = line.split(" ")
            key = word.downcase
            index = instance.to_i - 1
            memo[key] ||= []
            memo[key][index] = syllables
          end # data.each
        end # @dict
      end # def dict
    end # class << self
  end # module CMUDict
end # module NLTK