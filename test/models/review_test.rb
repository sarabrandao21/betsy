require "test_helper"

describe Review do
  describe 'relationships' do
    it 'belongs to a product' do
      review = reviews(:one)
      expect(review.valid?).must_equal true
      expect(review).must_respond_to :product
    end
  end

  describe 'validations' do
    it 'requires a reviewer ' do
      review = Review.new(product: products(:yogamat), rating: 5)

      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :reviewer
    end

    it 'will only accept rating of a range of 1 to 5' do
      review = Review.new(product: products(:yogamat), rating: -1)

      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
    end

    it 'will only accept rating of a range of 1 to 5' do
      review = Review.new(product: products(:yogamat), rating: 10)

      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
    end

    it 'require a product' do
      review = Review.new(reviewer: "Shonda", rating: 1)

      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :product
    end
  end
end