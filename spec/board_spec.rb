require_relative '../lib/board'

RSpec.describe Board do
  describe '#create_board' do
    context 'It makes the board correctly' do
      subject(:board) { described_class.new }
      xit 'creates a 8x8 board' do
        expect { board.create_board }.to change { board.grid.size }.by(64)
      end

      xit 'all initial elements are cells' do
        board.create_board
        expect(board.grid).to all(be_a(Cell))
      end
    end
  end

  describe '#refine_notation' do
    context 'it makes the notation usable' do
      it 'When a raw notation is passed' do
        notation = 'rbk/ppp/3/2p/rbq'
        expected = %w[r b k p p p emp emp emp emp emp p r b q]
        expect(described_class.new.refine_notation(notation)).to eql(expected)
      end
    end
  end

  describe '#verify_notation' do
    context 'checks if the given notation array is valid' do
      subject(:board) { described_class.new }
      let(:array) { [] }
      it 'validates the size' do
        allow(array).to receive(:all?).and_return(true)
        64.times { array << '' }
        expect(board.verify_notation(array)).to be_truthy
      end

      it 'checks for the values' do
        allow(array).to receive(:size).and_return(64)
        array << %w[p r emp q k n b]
        array.flatten!
        expect(board.verify_notation(array)).to be_truthy
      end

      it 'returns false on invalid numbers' do
        allow(array).to receive(:size).and_return(64)
        array << 'h'
        expect(board.verify_notation(array)).to be_falsy
      end
    end
  end

  describe '#get_color' do
    context 'it returns the correct color' do
      subject(:piece) { described_class.new }
      it 'returns black on lowercase letters' do
        expect(piece.get_color('p')).to eql('black')
      end

      it 'returns white on uppercase letters' do
        expect(piece.get_color('P')).to eql('white')
      end
    end
  end

  describe '#create_cell' do
    context 'It creates cells with the correct pieces' do
      subject(:piece) { described_class.new }
      it 'Creates a pawn on p' do
        allow(Pawn).to receive(:new).and_return('pawn')
        keyword = 'p'
        position = [1, 1]
        color = 'black'
        expect(Cell).to receive(:new).with([1, 1], 'pawn').once
        expect(Pawn).to receive(:new).with('black').once
        piece.create_cell(keyword, color, position)
      end

      it 'Creates a king on k' do
        allow(King).to receive(:new).and_return('king')
        keyword = 'k'
        position = [1, 2]
        color = 'white'
        expect(Cell).to receive(:new).with([1, 2], 'king').once
        expect(King).to receive(:new).with('white').once
        piece.create_cell(keyword, color, position)
      end
    end

    context 'It creates emppty squares when no keywords are passed' do
      subject(:empty_cell) { described_class.new }
      it 'When emp keyword is passed' do
        keyword = 'emp'
        position = [6, 7]
        expect(Cell).to receive(:new).with([6, 7], nil).once
        expect(Pieces).to_not receive(:new)
        empty_cell.create_cell(keyword, 'black', position)
      end
    end

    context 'It returns a Cell object' do
      subject(:cell) { described_class.new }
      it 'when p is passed' do
        expect(cell.create_cell('p', 'white', [5, 5])).to be_a Cell
      end
    end
  end

  describe '#fen_to_board' do
    subject(:board) { described_class.new }
    it 'changes grid size by 64' do
      allow(board).to receive(:get_color).and_return('')
      allow(board).to receive(:create_cell).and_return('')
      expect { board.fen_to_board(Array.new(64, '')) }.to change { board.grid.size }.by(64)
    end
  end

  describe '#refine_grid' do
    subject(:my_grid) { described_class.new }
    before do
      my_grid.create_new_board
      my_grid.instance_variable_set('@grid', my_grid.grid[0..1] + my_grid.grid[16..16] + my_grid.grid[-1..-1])
    end

    it 'Returns a refined grid' do
      expected = [[8, 1, 'brook'], [8, 2, 'bknight'], [6, 1], [1, 8, 'wrook']]
      expect(my_grid.refine_grid).to eql(expected)
    end
  end

  describe '#find_cell' do
    subject(:cell) { described_class.new }
    before do
      cell.create_new_board
    end

    it 'Returns the corrext index with location' do
      location = cell.grid[5].location
      expect(cell.find_cell(location)).to eql(5)
    end

    it 'returns the correct index with position' do
      position = cell.grid[5].position
      expect(cell.find_cell(position)).to eql(5)
    end
  end

  describe '#mark_grid' do
    context 'It updates the grid correctly' do
      subject(:cell) { described_class.new }
      before do
        cell.create_new_board
      end

      it 'When the black rook captures the white one' do
        cell1 = [8, 1]
        cell2 = [1, 1]
        piece = cell.grid[0].piece
        expect { cell.mark_grid(cell1, cell2) }.to change { cell.grid[56].piece }.to(piece)
                                                                                 .and change {
                                                                                        cell.grid[0].piece
                                                                                      }.to(nil)
      end
    end
  end
end