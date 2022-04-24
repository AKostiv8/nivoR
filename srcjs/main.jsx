import 'regenerator-runtime/runtime';
import { reactWidget } from 'reactR';
import AreaBump from './AreaBump';
import Choropleth from './Choropleth';

reactWidget('areabump', 'output', {
  AreaBumpCustom: AreaBump
});
reactWidget('choropleth', 'output', {
  ChoroplethTag: Choropleth
});
