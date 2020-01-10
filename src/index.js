import FizzBuzzView from './presentation/FizzBuzzView'

const view = new FizzBuzzView();
view.render();

if (process.env.NODE_ENV === 'production') {
  if (document.getElementById('dev')) {
    document.getElementById('dev').style.display = 'none'
  }
  if (document.getElementById('app-dev')) {
    document.getElementById('app-dev').style.display = 'none'
  }
}
