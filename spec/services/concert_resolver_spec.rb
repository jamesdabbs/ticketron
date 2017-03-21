# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe ConcertResolver do
  def concert_with_artists *names
    build :concert, artists: names.map { |n| build :artist, name: n }
  end
  let(:a) { concert_with_artists 'Why?', 'Eskimeaux' }
  let(:b) { concert_with_artists 'The Black Angels', 'A Place to Bury Strangers' }
  let(:c) { concert_with_artists 'San Fermin', 'Low Roar' }
  let(:d) { concert_with_artists 'Daughters', 'Dälek', 'Odonis Odonis' }
  let(:e) { concert_with_artists 'Something Else', 'Why?' }

  it 'can fuzzy match' do
    found = subject.call concerts: [a,b,c,d,e], query: 'daughters'
    expect(found).to eq [d]
  end

  it 'can fuzzy match' do
    found = subject.call concerts: [a,b,c,d,e], query: 'bury strangers'
    expect(found).to eq [b]
  end

  it 'can find multiple' do
    found = subject.call concerts: [a,b,c,d,e], query: 'why'
    expect(found).to eq [a,e]
  end
end
