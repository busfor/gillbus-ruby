require 'test_helper'

class GetBusImageTest < Minitest::Test
  def get_bus_image
    Gillbus::GetBusImage::Response.parse_string(File.read('test/responses/getBusImage.xml'))
  end

  def test_images_size
    assert_equal(1, get_bus_image.images.size)
  end

  def test_url
    url = 'https://s3-eu-central-1.amazonaws.com/gds-testing/ImagesBuses/46C13A4EA7C4453BE0530300F00ADDDD/IMG_1898.JPG'
    assert_equal(url, get_bus_image.images.first.url)
  end

  def test_thumb_url
    thumb_url = 'https://s3-eu-central-1.amazonaws.com/gds-testing/ImagesBuses/46C13A4EA7C4453BE0530300F00ADDDD/Thumb/_IMG_1898.JPG'
    assert_equal(thumb_url, get_bus_image.images.first.thumb_url)
  end
end
