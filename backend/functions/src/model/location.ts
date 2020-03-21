import { autoserialize, autoserializeAs } from 'cerialize'
import { Position } from './position'

export class Location {
    @autoserialize public id: string;
    @autoserializeAs(Position) public position: Position;

    constructor(
        id: string,
        position: Position
    ) {
        this.id = id;
        this.position = position;
    }
}

