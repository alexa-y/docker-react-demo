RSpec.describe 'dashboard', type: :feature do
  before :each do
    Post.create title: 'test'
  end

  it 'does stuff', js: true do
    visit root_path
    id = Post.last.id
    puts id.to_s
    click_button id.to_s
    expect(page.has_button?(id.to_s)).to be_falsey
    expect(page.has_button?((id + 1).to_s)).to be_truthy
  end
end
